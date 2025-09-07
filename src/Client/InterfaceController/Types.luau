--!strict

-- Slarea Frame Types

export type SlareaFrameProto = {
	__index: SlareaFrameProto,

	new: (name: string, screenGui: ScreenGui) -> SlareaFrame,
	AddPlot: (SlareaFrame, Plot) -> (),
	
	_accommodate: (SlareaFrame) -> ()
}

export type SlareaFrame = typeof(setmetatable({} :: {
	Frame: Frame,
	
	_plotFrame: Frame?,
	_plots: {Plot}
}, {} :: SlareaFrameProto))

-- Other types

export type BoxSpacing = {
	Left: number,
	Right: number,
	Bottom: number,
	Top: number
}

-- Plot Types

-- Line Plot

export type LinePlotProto = {
	__index: LinePlotProto,

	new: (SlareaFrame, string?)->LinePlot,
	PlotData: (LinePlot, {Vector2})->(),
	GetSize: (LinePlot) -> Vector2,
}

export type LinePlot = typeof(setmetatable({} :: {
	Parent: SlareaFrame,
	Frame: Frame,
	GridLineFrame: Frame,
	Path2D: Path2D,
	
	Axis: {
		X: Axis,
		Y: Axis
	},
	
	Header: Label?,
	
	LowerBound: {
		X: number,
		Y: number
	},
	
	PlotScale: {
		X: number,
		Y: number
	}
}, {} :: LinePlotProto))

-- General Plot Type

export type Plot = LinePlot

-- Frame Element Types

-- Axis

export type AxisProto = {
	__index: AxisProto,
	
	new: (Plot, AxisOrientation, number)->Axis,	
	UpdateTicks: (Axis, number, number)->(),
	
	_setupHorizontal: (Axis)->(),
	_setupVertical: (Axis)->(),
}

export type Axis = typeof(setmetatable({} :: {
	Parent: Plot,
	Frame: Frame,
	
	_ticks: {Frame},	
	_tickLabels: {TextLabel},
	_gridLines: {Frame},
	
	_orientation: AxisOrientation,
	_numTicks: number,
}, {} :: AxisProto)) 

export type AxisOrientation = "Horizontal" | "Vertical"

-- Label

export type LabelProto = {
	__index: LabelProto,
	
	newPlotLabel: (parent: Plot, text: string)->Label,
	newAxisLabel: (parent: Axis, text: string)->Label,
	
	GetSize: (Label) -> Vector2,
}

export type Label = typeof(setmetatable({} :: {
	Parent: Plot | Axis,
	
	_textLabel: TextLabel
}, {} :: LabelProto))

return nil
