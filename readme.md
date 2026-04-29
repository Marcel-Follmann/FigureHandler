# 🚀 Usage
Import the repository into your Matlab project via

```
git submodule add https://github.com/Marcel-Follmann/FigureHandler +Figurehandler
```

Then initialize the figure handler and a figure cell array as
```
fh = Figurehandler.Create("savePath","01_Figures\");
f = {};
``` 
to set the output path to "01_Figures". 

Add each figure to the figure array
```
f{end+1} = figure("Name", <File_Name>)
```

Finally, format and generate the figures via
```
for i = 1:numel(f)
    fh.PrepareSvg(f{i});
end
fh.GenerateOutputs;
```
for the respective output format (svg, pdf, emf).