--!strict

-- Slarea Frame Types

export type SlareaFrameProto = {
	__index: SlareaFrameProto,

	new: (name: string, screenGui: ScreenGui) -> SlareaFrame,
	AddPlot: (SlareaFrame, LinePlot) -> (),
	
	_accommodate: (SlareaFrame) -> ()
}

export type SlareaFrame = typeof(setmetatable({} :: {
	Frame: Frame,
	
	_plots: {LinePlot}
}, {} :: SlareaFrameProto))

-- Plot Types

-- Base Plot Type 

-- Line Plot

export type LinePlotProto = {
	__index: LinePlotProto,
	
	new: ()->LinePlot,
	PlotData: (LinePlot, {Vector2})->(),
	ClearPlot: (LinePlot) -> (),
}

export type LinePlot = typeof(setmetatable({} :: {
	Frame: Frame,
	_points: {Frame},
	_lines: {Frame}
}, {} :: LinePlotProto))


return nil
