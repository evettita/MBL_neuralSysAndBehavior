function abfConvert( abfDir )

cd (abfDir)

names = dir('*.abf');


for ii = 1:length(names)
    
    [d{ii},si{ii},h{ii}] = abfload2([abfDir '\'  names(ii).name],'channels','a','start',0,'stop', 'e');
    
end


% save data into the new file dir:
save([abfDir '\d'], 'd')
save([abfDir '\h'], 'h')
save([abfDir '\si'], 'si')
   







