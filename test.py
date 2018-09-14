import onaji
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity


def setup():
    collection = onaji.ImageCollection()
    collection.add('IMG_20170323_072950.jpg')
    collection.add('IMG_20170329_133205.jpg')
    return collection

def vis():
    collection = setup()
    #roi = onaji.Roi(0.3, 0.3, 0.2, 0.2)
    roi = onaji.Roi(5/16, 6/21, 3/16, 3/21)
    query = collection.images[1].get_feature(roi)
    result = collection.compare(query)
    collection.images[1].show(roi=roi)
    im0_best_index = result[0][0]
    print(im0_best_index)
    print(result[0][1])
    best_roi = result[0][2][im0_best_index]
    print(best_roi)
    collection.images[0].show(roi=best_roi)

    test = collection.images[0].get_feature(best_roi)
    print(cosine_similarity(query.reshape(1, -1), test.reshape(1, -1)))

def pooling():
    collection = setup()
    features = collection.images[0].features
    result = onaji.expand_features(features)
    print(result)

def test_roi():
    collection = setup()
    roi = onaji.Roi(0.3, 0.3, 0.2, 0.2)
    query = collection.images[1].get_feature(roi)
    result = collection.compare(query)
    rois = result[0][2]
    collection.images[0].show(roi=rois[0])
    collection.images[0].show(roi=rois[1])
    collection.images[0].show(roi=rois[-1])

if __name__ == '__main__':
    vis()
