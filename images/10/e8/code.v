module fan_speed_control (
    input [3:0] temperature,
    input [1:0] control,
    output reg [1:0] fan_speed
);
    always @(temperature or control) begin
        if (control == 2'b11) begin
            fan_speed = 2'b00; // Fan off
        end else if (temperature < 20) begin
            fan_speed = 2'b00; // Low speed
        end else if (temperature >= 20 && temperature <= 30) begin
            fan_speed = 2'b01; // Medium speed
        end else begin
            fan_speed = 2'b10; // High speed
        end
    end
endmodule