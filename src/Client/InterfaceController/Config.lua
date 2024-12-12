return table.freeze({
	Interface = {
		Defaults = {
			SlareaFrame = {
				Frame = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				}
			},
			
			Plots = {
				Scatter = {
					Frame = {
						Size = UDim2.fromOffset(500, 300)
					},
				},
				Bar = {
					Frame = {
						Size = UDim2.fromOffset(500, 300)
					}
				}
			},
			
			PlotComponents = {
				Point = {
					Frame = {
						Size = UDim2.fromOffset(2, 2),
						BackgroundColor3 = Color3.fromRGB(0, 170, 255),
						BorderSizePixel = 0 
					}
				},
				Bar = {
					Frame = {
						BackgroundColor3 = Color3.fromRGB(0, 170, 255), 
						BorderSizePixel = 0
					}
				}
			}
		}
	}
})
