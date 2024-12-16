return table.freeze({
	Interface = {
		Defaults = {
			SlareaFrame = {
				Frame = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
				},
				Plots = {
					Margin = Vector2.new(50, 50)
				}
			},
			
			Plots = {
				Line = {
					Frame = {
						Size = UDim2.fromOffset(500, 300),
						BackgroundColor3 = Color3.fromRGB(34, 34, 34),
						BorderSizePixel = 1,
						BorderColor3 = Color3.fromRGB(230, 230, 230)
					},
					Bounds = {
						Left = 0,
						Right = 0,
						Bottom = 0.1,
						Top = 0.1 
					},
					Padding = {
						Left = 0.1,
						Right = 0.1,
						Bottom = 0,
						Top = 0, 
					}
				},
			},
			
			PlotElements = {
				Axis = {
					Size = {
						Width = 50,
						Height = 50
					},
					Frame = {
						BackgroundTransparency = 1,
					}, 
				}
			},
			
			PlotComponents = {
				Point = {
					Frame = {
						Size = UDim2.fromOffset(5, 5),
						BackgroundColor3 = Color3.fromRGB(0, 170, 255),
						BorderSizePixel = 0 
					}
				},
				Line = {
					Frame = {
						BackgroundColor3 = Color3.fromRGB(0, 170, 255),
						BorderSizePixel = 0
					},
				},
			}
		}
	}
})
