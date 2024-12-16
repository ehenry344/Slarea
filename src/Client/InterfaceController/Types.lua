--!strict

-- Slarea Frame Types

export type SlareaFrameProto = {
	__index: SlareaFrameProto,

	new: (name: string, screenGui: ScreenGui) -> SlareaFrame,
	AddPlot: (SlareaFrame, LinePlot) -> (),
	GetPlotFrame: (SlareaFrame) -> Frame,
	
	_accommodate: (SlareaFrame) -> ()
}

export type SlareaFrame = typeof(setmetatable({} :: {
	Frame: Frame,
	
	_plotFrame: Frame?,
	_plots: {LinePlot}
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
	
	new: (SlareaFrame)->LinePlot,
	PlotData: (LinePlot, {Vector2})->(),
	ClearPlot: (LinePlot) -> (),
	GetSize: (LinePlot) -> Vector2,
	
	_makeLine: (LinePlot, number, Frame, Frame) -> (),
}

export type LinePlot = typeof(setmetatable({} :: {
	Parent: SlareaFrame,
	Frame: Frame,
	
	_points: {Frame},
	_lines: {Frame},
	
	_axis: {
		X: Axis,
		Y: Axis
	},
	
	_frameBounds: BoxSpacing,
	_padding: BoxSpacing
}, {} :: LinePlotProto))

-- General Plot Type

export type Plot = LinePlot

-- Frame Element Types

-- Axis

export type AxisProto = {
	__index: AxisProto,
	
	new: (Plot, AxisOrientation, number, BoxSpacing)->Axis,	
	UpdateTicks: (Axis, number, number, number, number)->(),
	
}

export type Axis = typeof(setmetatable({} :: {
	Parent: Plot,
	Frame: Frame,
	
	_ticks: {Frame},	
	
	_orientation: AxisOrientation,
	_numTicks: number,
}, {} :: AxisProto)) 

export type AxisOrientation = "Horizontal" | "Vertical"

return nil
