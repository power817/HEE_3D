(* ::Package:: *)

Do[
net[i]=Import["onnx/model_"<>ToString[i]<>".onnx","NetExternalObject"]
,{i,1,101}]


geogen[lzt_]:=Module[{result,tgt},

tgt=ArrayReshape[Table[1,{i,Dimensions[lzt][[1]]}],{Dimensions[lzt][[1]],1,1}]//N;
out=tgt;
Do[
result=net[i][<|"src"->lzt,"tgt"->tgt|>];
tgt=MapThread[Append,{tgt,result[[All,-1]]}]//N;
out=tgt;
,{i,1,100}];
tgt
]


findlzt[func_]:=Module[{lzt},lzt =Table[l/.FindRoot[D[func,l]==1/(2 zt)/.zh-> 1+10^-5,{l,10^-5}],{zt,0+10^-7,1+10^-7,0.01}];
lzt=ArrayReshape[N[lzt],{101,1}];
lzt]
