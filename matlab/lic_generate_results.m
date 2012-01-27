function lic_generate_results(output_file_name)
    matlabpool open
    data = cell(5000,1);
    parfor i = 1:5000
        fprintf('%d/%d\n', i, 5000);
        data{i} = get_label_string(lic_detect(i));
    end
    save(output_file_name, 'data')
    matlabpool close
end

