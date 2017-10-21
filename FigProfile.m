(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* :Title: FigShape *)
(* :Context: SciDraw` *)
(* :Summary: Basic drawing shapes *)
(* :Author: Mark A. Caprio, Department of Physics, University of Notre Dame *)
(* :Copyright: Copyright FIGYEAR, Mark A. Caprio *)
(* :Package Version: FIGVERSION *)
(* :Mathematica Version: MATHVERSION *)
(* :Discussion: FIGDISCUSSION *)
(* :History: See package information file. *)


BeginPackage["SciDraw`",SciDraw`Private`$ExternalContexts];


Unprotect[Evaluate[$Context<>"*"]];


FigTest1::usage="FIGURE OBJECT.";


Begin["`Private`"];





DeclareFigClass[
FigTest1,
{"Points"},  (* data members *)
{},  (* member functions *)
{}  (* attached labels *)
];
DefineFigClassOptions[
FigTest1,
{
(* curve/arrowhead *)
FigArrowheadOptions[False,False],
FigCurveOptions,
"Draw"->True
}
];


Constructor[Class:FigTest1,Self_Object][Curve:FigCurvePattern,Opts___?OptionQ]:=FigObjectWrapper[Class,Self,{Opts},
Module[
{CanvasPoints,InterpolationFunction},

(* validate extra options *)
FigCheckArrowheadOptions[Self];
FigCheckCurveOptions[Self];

(* prerequisite calculations *)
CanvasPoints=FigResolveCurve[Self,Curve,FigOptions];

(* save data needed for anchor generation *)
Self@SetPoints[CanvasPoints];

(* make graphics elements *)
If[
TrueQ[("Draw"/.FigOptions)],
(* curve *)
FigLineElement[
{Line[CanvasPoints]},
FigOptions
];
(* arrowheads *)
FigLineElement[
{Line[FigCurveArrowheadPoints[
Self@MakeAnchor[Tail,None],
Self@MakeAnchor[Head,None],
FigOptions
]]},
Flatten[{LineDashing->None,FigOptions}]
]
];

]
];


MakeAnchor[Class:FigTest1,Self_Object][Name_,Arg:_]:=FigMakeAnchorWrapper[Class,Self,Name,Arg,
FigCurveAnchorFromPoints[Self@GetPoints[],Name,Arg]
];


MakeBoundingBox[Class:FigTest1,Self_Object][]:=FigCurveBoundingBox[Self@GetPoints[]];


End[];


Protect[Evaluate[$Context<>"*"]];
Unprotect[Evaluate[$Context<>"$*"]];
EndPackage[];
