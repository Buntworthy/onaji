classdef Progress < handle
    
    properties
        Message
        TotalTime = 0
        TotalSteps
        FullMessage
        DeleteString = ''
    end
    
    methods
        function this = Progress(msg, total)
            this.Message = msg;
            this.TotalSteps = total;
            tic
            this.update(0)
        end
        
        function update(this, current)
            if current >= this.TotalSteps
                fprintf([this.DeleteString, 'Done.']);
                this.delete();
            else
                this.TotalTime = toc;
                percentString = sprintf('%2.1f%%%%.', 100*current/this.TotalSteps);
                x = current/this.TotalSteps;
                remainString = sprintf('Estimated time remaining = %2.1fs', ...
                                    this.TotalTime/x*(1-x));
                this.FullMessage = sprintf('%s %s %s\n', this.Message, percentString, remainString);
                fprintf([this.DeleteString, this.FullMessage]);
                this.DeleteString = repmat('\b', 1, numel(this.FullMessage)-1);
            end
        end
    
    end
    
end