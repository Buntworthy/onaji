import torch
import torch.nn as nn
import torchvision.models as models
import torchvision.transforms as transforms
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from sklearn.metrics.pairwise import cosine_similarity
import PIL

import math
from glob import glob

def get_net():
    """Returns a feature extraction network."""

    resnet50 = models.resnet50(pretrained=True)
    resnet_features = nn.Sequential(*list(resnet50.children())[:-2])

    for param in resnet_features.parameters():
        param.requires_grad = False

    return resnet_features


def extract_features(net, image):
    """Extract features from an image using a network."""

    final_size = 500
    normalize = transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225],
        )

    preprocess = transforms.Compose([
        transforms.Resize(final_size),
        transforms.ToTensor(),
        normalize,
        ])

    input_image = preprocess(image).unsqueeze(0)
    features = net(input_image).numpy()
    return features
    

def plot_feature_location(im, feature_point, map_size):
    """Plots a feature location on an image.
    feature_point and map size should be in (y, x).
    """
    
    plt.imshow(im)
    plt.scatter([feature_point[1]/map_size[1]*im.size[0]], 
                [feature_point[0]/map_size[0]*im.size[1]], 
                c=(1,0,0))
    plt.show()

def feature_from_map(features, feature_point):
    """Returns the single feature at feature_point (y,x)"""
    single_feature = features[0, :, feature_point[0], feature_point[1]]
    return np.reshape(single_feature, (1, -1))

class Roi():
    """Represents a region of interest in an image."""

    def __init__(self, x, y, width, height, units='fractional'):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.x_end = self.x + self.width
        self.y_end = self.y + self.height
        self.units = units

    def scale(self, output_size):
        """Scales a fractional roi to a an absolute size."""
        if self.units != 'fractional':
            raise RuntimeError("Only fractional Rois can be scaled.")

        abs_x = self.x * output_size[0]
        abs_y = self.y * output_size[1]
        abs_width = self.width * output_size[0]
        abs_height = self.height * output_size[1]
        return Roi(abs_x, abs_y, abs_width, abs_height, units='absolute')

    def __repr__(self):
        return f"{self.x}, {self.y}, {self.width}, {self.height}"



class Image():

    def __init__(self, filename, features):
        self._pil_image = PIL.Image.open(filename)
        self.width = self._pil_image.size[0]
        self.height = self._pil_image.size[1]
        self.features = features[0, :, :, :]
        self.feature_size = self.features.shape[1:]
        self.feature_length = self.features.shape[0]

    def get_feature(self, roi):
        """Returns the feature for a particular ROI.
        ROI should be of the form x, y, width, height."""
        scaled_roi = roi.scale(self.feature_size[::-1])
        roi_features = self.features[:, int(scaled_roi.y):int(scaled_roi.y_end),
                                     int(scaled_roi.x):int(scaled_roi.x_end)]
        roi_features = np.reshape(roi_features, (self.feature_length, -1))
        return np.amax(roi_features, axis=1)

    def compare(self, query):
        """Compare a query vector against the features."""
        flat_features, rois = expand_features(self.features)
        print(flat_features.shape)
        distances = cosine_similarity(query.reshape(1, -1), flat_features.T)
        return distances, rois

    def show(self, roi=None):
        """Display the image.
        An optional roi can be specified."""
        fig, ax = plt.subplots(1)
        ax.imshow(self._pil_image)
        if roi:
            if roi.units == 'fractional':
                roi = roi.scale((self.width, self.height))

            rect = matplotlib.patches.Rectangle(
                (roi.x, roi.y),
                roi.width, roi.height,
                linewidth=2, edgecolor='r', facecolor='none')
            ax.add_patch(rect)
        plt.show()


def expand_features(features):
    """Make expanded set of features."""
    input_size = features.shape[1:3]
    num_features = features.shape[0]
    pool_size = 3
    stride_size = math.floor(pool_size/2)

    width = pool_size/input_size[1]
    height = pool_size/input_size[0]
    x = np.arange(0, input_size[1] - pool_size + 1, stride_size)/input_size[1]
    y = np.arange(0, input_size[0] - pool_size + 1, stride_size)/input_size[0]
    print(x)
    print(y)
    roi_list = []
    for y_pos in y:
        for x_pos in x:
            roi_list.append(Roi(x_pos, y_pos, width, height))

    pool = nn.MaxPool2d(pool_size, stride=stride_size)
    pool_output = pool(torch.unsqueeze(torch.from_numpy(features), 0))
    pooled_features = pool_output.numpy()[0, :, :, :]
    pooled_features = np.reshape(pooled_features, (pooled_features.shape[0], -1))
    print(len(roi_list))
    print(pooled_features.shape)
    return (pooled_features, roi_list)


class ImageCollection():
    """Creates all the Image objects."""

    def __init__(self):
        self.images = []
        self.net = get_net()

    def add_directory(self, directory):
        image_files = glob(directory + '/*.jpg')
        for image_file in image_files:
            self.add(image_file)

    def add(self, filename):
        """Add an image to the collection."""
        image_data = PIL.Image.open(filename)
        features = extract_features(self.net, image_data)
        self.images.append(Image(filename, features))

    def compare(self, query):
        """Compare a query features against the database."""
        results = []
        for image in self.images:
            result, rois = image.compare(query)
            best_index = np.argmax(result)
            best_score = np.amax(result)
            results.append((best_index, best_score, rois))
        return results
