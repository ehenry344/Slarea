return table.freeze({
	Interface = {
		Defaults = {
			SlareaFrame = {
				Frame = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.8, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
				},
				Plots = {
					Margin = Vector2.new(0, 0)
				}
			},
			
			Plots = {
				Line = {
					Ticks = {
						Horizontal = 10, 
						Vertical = 10
					},
					Frame = {
						Size = UDim2.fromOffset(500, 300),
						BackgroundColor3 = Color3.fromRGB(241, 241, 241),
						BorderSizePixel = 1,
						BorderColor3 = Color3.fromRGB(72, 72, 72)
					},
					Bounds = {
						Left = 0.05,
						Right = 0.05,
						Bottom = 0.05,
						Top = 0.05 
					},
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
					Ticks = {
						Size = {
							Horizontal = UDim2.fromOffset(3, 6),
							Vertical = UDim2.fromOffset(6, 3) 
						},
						Frame = {
							BorderSizePixel = 0,
							BackgroundColor3 = Color3.fromRGB(72, 72, 72),
						}
					},
					TickLabels = {
						Constants = {
							RoundingPrecision = 2, -- hundredths place
						}
					},
					GridLines = {
						Frame = {
							BorderSizePixel = 0,
							BackgroundColor3 = Color3.fromRGB(209, 209, 209),
							
						}
					}
				}
			},
			
			PlotComponents = {
				Line = {
					BackgroundColor3 = Color3.fromRGB(0, 170, 255),
					BorderSizePixel = 0
				},
			}
		}
	}
})
