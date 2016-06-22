function tf = opttf(pval, okarg, matlabfile)
%OPTTF determines whether input options are true or false
%
%   TF = OPTTF(PVAL, OKARG, MATLABFILE) evaluates the value PVAL of
%   property OKARG for logical TF and errors if the intended valus is
%   invalid. 

% Copyright 2008-2012 The MathWorks, Inc.


if islogical(pval)
    tf = all(pval);
    return
end
if isnumeric(pval)
    tf = all(pval~=0);
    return
end
if ischar(pval)
    truevals = {'true','yes','on','t'};
    k = any(strcmpi(pval,truevals));
    if k
        tf = true;
        return
    end
    falsevals = {'false','no','off','f'};
    k = any(strcmpi(pval,falsevals));
    if k
        tf = false;
        return
    end
end
if nargin == 1
    % return empty if unknown value
    tf = logical([]);
else
    okarg(1) = upper(okarg(1));
    msg = getString(message('bioinfo:opttf:OptionNotLogical',upper(okarg)));
    msgId = sprintf('bioinfo:%s:%sOptionNotLogical', matlabfile, okarg);
    x = MException(msgId,msg);
    x.throwAsCaller;
end
end % opttf function
