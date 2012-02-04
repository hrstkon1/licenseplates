function lic_generate_results(output_file_name)
    global data
    load('../data/np-images-5000.mat');   
    matlabpool open
    results = cell(5000,1);
    parfor i = 1:5000
        fprintf('%d/%d\n', i, 5000);
        results{i} = lic_detect(i, 0, 0, data);
    end
    save(output_file_name, 'results')
    matlabpool close
end

