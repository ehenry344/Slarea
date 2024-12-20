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
	
	new: (SlareaFrame)->LinePlot,
	PlotData: (LinePlot, {Vector2})->(),
	ClearPlot: (LinePlot) -> (),
	GetSize: (LinePlot) -> Vector2,
	
	_makeLine: (LinePlot, number, Frame, Frame) -> (),
}

export type LinePlot = typeof(setmetatable({} :: {
	Parent: SlareaFrame,
	Frame: Frame,
	
	Axis: {
		X: Axis,
		Y: Axis
	},
	
	_points: {Frame},
	_lines: {Frame},
	
	_mins: {
		X: number,
		Y: number
	},
	
	_dists: {
		X: number, 
		Y: number
	}
}, {} :: LinePlotProto))

-- Line Plot Without Points! (for testing)

export type LinePlotNpProto = {
	__index: LinePlotNpProto,

	new: (SlareaFrame)->LinePlotNp,
	PlotData: (LinePlotNp, {Vector2})->(),
	GetSize: (LinePlotNp) -> Vector2,

	_makeLine: (LinePlotNp, number, Vector2, Vector2) -> (),
	_getFrame: (LinePlotNp, number) -> Frame,
	_reserve: (LinePlotNp, number) -> ()
}

export type LinePlotNp = typeof(setmetatable({} :: {
	Parent: SlareaFrame,
	Frame: Frame,
	
	Axis: {
		X: Axis,
		Y: Axis
	},
	
	LowerBound: {
		X: number,
		Y: number
	},
	
	PlotScale: {
		X: number,
		Y: number,
	},

	_deployedFrames: {Frame},
	_reserveFrames: {Frame}
}, {} :: LinePlotNpProto))

-- General Plot Type

export type Plot = LinePlotNp

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

return nil
