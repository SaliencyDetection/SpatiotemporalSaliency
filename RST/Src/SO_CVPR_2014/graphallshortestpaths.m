function dist = graphallshortestpaths(G,varargin)
%GRAPHALLSHORTESTPATHS finds all the shortest paths in graph.
% 
% DIST = GRAPHALLSHORTESTPATHS(G) shortest paths between every pair of
% nodes in the graph G. G is a sparse matrix that represents an n-by-n
% adjacency matrix. Nonzero entries in the matrix represent the weights of
% the edges. 
%
% DIST is an n-by-n matrix where DIST(S,D) is the distance of the shortest
% path from node S to node D. Elements in the diagonal of this matrix are
% always zero. Any zero not in the diagonal indicates that the distance
% between the source and target nodes is zero. An Inf indicates that there
% is no path between the source and target nodes.
% 
% MATLAB uses Johnson's algorithm to find the shortest paths. This
% algorithm has a time complexity of O(n*log(n)+n*e), where n and e are
% number of nodes and edges respectively.
% 
% GRAPHALLSHORTESTPATHS(...,'DIRECTED',false) indicates that the graph G is
% undirected, the upper triangle of the G is ignored. Default is true.
% 
% GRAPHALLSHORTESTPATHS(...,'WEIGHTS',W) provides custom weights for the
% edges, useful to indicate zero valued weights. W is a column vector with
% one entry for every edge in G, traversed column-wise.
% 
% Examples:
%   % Create a directed graph with 6 nodes and 11 edges
%   W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
%   DG = sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],W)
%   h = view(biograph(DG,[],'ShowWeights','on'))
%   % Find all the shortest paths
%   graphallshortestpaths(DG)
%
%   % Solving the previous problem for an undirected graph
%   UG = tril(DG + DG')
%   h = view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'))
%   % Find all the shortest paths
%   graphallshortestpaths(UG,'directed',false)
%
% See also: GRAPHCONNCOMP, GRAPHISDAG, GRAPHISOMORPHISM, GRAPHISSPANTREE,
% GRAPHMAXFLOW, GRAPHMINSPANTREE, GRAPHPRED2PATH, GRAPHSHORTESTPATH,
% GRAPHTHEORYDEMO, GRAPHTOPOORDER, GRAPHTRAVERSE.
%
% Reference: 
%  [1]	D.B. Johnson. "Efficient algorithms for shortest paths in sparse
%       networks" Journal of the ACM, 24(1):1-13, 1977. 

%   Copyright 2006-2008 The MathWorks, Inc.


debug_level = 0;

% set defaults of optional input arguments
W = []; % no custom weights
directed = true;

% read in optional PV input arguments
nvarargin = numel(varargin);
if nvarargin
    if rem(nvarargin,2) == 1
        error(message('bioinfo:graphallshortestpaths:IncorrectNumberOfArguments', mfilename));
    end
    okargs = {'directed','weights'};
    for j=1:2:nvarargin-1
        pname = varargin{j};
        pval = varargin{j+1};
        k = find(strncmpi(pname,okargs,numel(pname)));
        if isempty(k)
            error(message('bioinfo:graphallshortestpaths:UnknownParameterName', pname));
        elseif length(k)>1
            error(message('bioinfo:graphallshortestpaths:AmbiguousParameterName', pname));
        else
            switch(k)
                case 1 % 'directed'
                    directed = opttf(pval,okargs{k},mfilename);
                case 2 % 'weights'
                    W = pval(:);
            end
        end
    end
end

% call the mex implementation of the graph algorithms
if isempty(W)
    dist = graphalgs('all',debug_level,directed,G);
else
    dist = graphalgs('all',debug_level,directed,G,W);
end
