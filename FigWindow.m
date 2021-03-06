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



(* :Title: FigWindow *)
(* :Context: SciDraw`FigWindow` *)
(* :Summary: Coordinate system infrastructure *)
(* :Author: Mark A. Caprio, Department of Physics, University of Notre Dame *)
(* :Copyright: Copyright FIGYEAR, Mark A. Caprio *)
(* :Package Version: FIGVERSION *)
(* :Mathematica Version: MATHVERSION *)
(* :Discussion: FIGDISCUSSION *)
(* :History: See main package file. *)


BeginPackage["SciDraw`",SciDraw`Private`$ExternalContexts];


Unprotect[Evaluate[$Context<>"*"]];


Begin["`Private`"];





TransformRegion[TransformationFunction_,r:{{x1_?NumericQ,x2_?NumericQ},{y1_?NumericQ,y2_?NumericQ}}]:=Module[
{Corners,ScaledCorners},
Corners=Transpose[r];
ScaledCorners=Map[TransformationFunction,Corners];
(*Global`xsc=ScaledCorners;*)
(*Print[Global`xsc];*)
(*Print[Evaluate[ScaledCorners]];*)
Transpose[ScaledCorners]
]


Constructor[FigWindow,Self_Object][
r:{{x1_?NumericQ,x2_?NumericQ},{y1_?NumericQ,y2_?NumericQ}}
]:=Module[
{},

(* region *)
Self@SetRegion[r];

(* transformation *)
Self@SetTFunction[ScalingTransform[{1,1}]];

];


Constructor[FigWindow,Self_Object][
r:{{x1_?NumericQ,x2_?NumericQ},{y1_?NumericQ,y2_?NumericQ}},
rp:{{x1p_?NumericQ,x2p_?NumericQ},{y1p_?NumericQ,y2p_?NumericQ}}
]:=Module[
{},

(* region *)
Self@SetRegion[rp];

(* transformation *)
Self@SetTFunction[RescalingTransform[rp,r]];

];


UserRegion[FigWindow,Self_Object][]:=(Self@GetRegion[]);
CanvasRegion[FigWindow,Self_Object][]:=TransformRegion[(Self@GetTFunction[]),(Self@GetRegion[])];


HomogenizeTransform[tfcn_TransformationFunction]:=AffineTransform[TransformationMatrix[tfcn][[1;;2,1;;2]]];


TFunction[FigWindow,Self_Object][]:=(Self@GetTFunction[]);
InverseTFunction[FigWindow,Self_Object][]:=InverseFunction[Self@GetTFunction[]];
DeltaTFunction[FigWindow,Self_Object][]:=HomogenizeTransform[Self@GetTFunction[]];
ScaledTFunction[FigWindow,Self_Object][]:=Composition[
(Self@GetTFunction[]),
RescalingTransform[{{0,1},{0,1}},Self@GetRegion[]]
];
ScaledDeltaTFunction[FigWindow,Self_Object][]:=HomogenizeTransform[Self@ScaledTFunction[]];


SetAttributes[WithOrigin,{HoldRest}];


WithOrigin[
p:FigPointPattern,
Body_
]:=Module[
{Window,CanvasShift,NewOrigin},

(* validation *)
FigCheckInFigure[WithOrigin];

(* create window covering same canvas region as current window *)
Window=FigWindow[CurrentWindow[]@GetRegion[]];

(* calculate shift amount on canvas *)
(* must shift user {0,0} to new canvas point p origin *)
NewOrigin=FigResolvePoint[p];
CanvasShift=NewOrigin-FigResolvePoint[{0,0}];
Window@SetTFunction[Composition[TranslationTransform[CanvasShift],CurrentWindow[]@GetTFunction[]]];

Block[
{$CurrentWindow=Window},
(* evaluate body *)
Body
]

];
WithOrigin[x_?NumericQ,Body_]:=WithOrigin[{x,0},Body];
DeclareFigFallThroughError[WithOrigin];


SetAttributes[WithClipping,{HoldRest}];


WithClipping[
r:FigRegionPattern,
Body_
]:=Module[
{Window,NewCanvasRegion,NewUserRegion},

(* validation *)
FigCheckInFigure[WithClipping];

(* create window covering new canvas region, but with same transformation functions as current window *)
NewCanvasRegion=FigResolveRegion[r];
NewUserRegion=TransformRegion[CurrentWindow[]@InverseTFunction[],NewCanvasRegion];
Window=FigWindow[NewUserRegion];
Window@SetTFunction[CurrentWindow[]@GetTFunction[]];

ShowObject[$CurrentWindow];
Block[
{$CurrentWindow=Window},
ShowObject[$CurrentWindow];
(* evaluate body *)
(* all that wonderfull flattening/clipping/rasterization is imposed *)
(* note: could use FigureGroup-like call*)
FigCompositeElement[
CollectGraphicalElements[
Body,
CurrentWindow[],CurrentBackground[]
],
CurrentWindow[],$FigDrawingLayer
(*FilterRules[FigOptions,Options[FigCompositeElement]]*)
]
]

];
DeclareFigFallThroughError[WithClipping];


End[];


Protect[Evaluate[$Context<>"*"]];
Unprotect[Evaluate[$Context<>"$*"]];
EndPackage[];
