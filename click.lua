local VirtualUser = game:GetService("VirtualUser")

while true do
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(9999,9999))
    task.wait(0.000001) -- tốc độ click
end
