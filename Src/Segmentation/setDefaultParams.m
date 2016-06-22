function [ params ] = setDefaultParams( method )

    switch method
        case 'TSP'
            params = setDefaultTSPParams();
        case 'SLIC'
            params = setDefaultSLICParams();
        case 'Pedro'
            params = setDefaultPedroParams();
    end

	params.FlowType = 'forward'; %{'forward', 'backward'}
	switch (params.FlowType)
        case 'forward'
            params.f=1;
        case 'backward'
            params.f=2;
	end

end

