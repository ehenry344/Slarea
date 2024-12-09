--!strict

-- Slarea Frame Types

export type SlareaFrameProto = {
	__index: SlareaFrameProto,

	new: (frameId: number) -> SlareaFrame,
	Mount: (SlareaFrame, ScreenGui) -> (),

	_accommodate: (SlareaFrame) -> ()
}

export type SlareaFrame = typeof(setmetatable({} :: {
	_frame: Frame,
	
	_plots: {Plot}
}, {} :: SlareaFrameProto))

-- Plot Element Types 

-- T = base element type

type BaseElementProto<P, T> = {
	__index: P,
	
	new: () -> T,
	Mount: (T, Frame) -> ()
}

-- Bar Element (For Bar Graphs)

export type BarElementProto = BaseElementProto<BarElementProto, BarElement> & {
	SetPosition: (BarElement, pos: Vector2, xOffset: number, yOffset: number) -> (),
	SetSize: (BarElement, Vector2) -> ()
}

export type BarElement = typeof(setmetatable({} :: {
	_guiObject: Frame
}, {} :: BarElementProto))

-- Point Element

export type PointElementProto = BaseElementProto<PointElementProto, PointElement> & {
	SetPosition: (PointElement, pos: Vector2, xOffset: number, yOffset: number) -> ()
}

export type PointElement = typeof(setmetatable({} :: {
	_guiObject: Frame
}, {} :: PointElementProto))

-- Plot Types

-- Base Plot Type 
type BasePlotProto<P, T> = {
	__index: P,
	
	new: (Frame) -> T,
}

-- Bar Plot

export type BarPlotProto = BasePlotProto<BarPlotProto, BarPlot> & {
		
} -- nothing for now

export type BarPlot = typeof(setmetatable({} :: {
	_frame: Frame,
	_bars: {BarElement}
}, {} :: BarPlotProto))


-- Scatter Plot

export type ScatterPlotProto = BasePlotProto<ScatterPlotProto, ScatterPlot> & {}

export type ScatterPlot = typeof(setmetatable({} :: {
	_frame: Frame,
	_points: {PointElement}
}, {} :: ScatterPlotProto))

export type Plot = BarPlot | ScatterPlot

return nil
