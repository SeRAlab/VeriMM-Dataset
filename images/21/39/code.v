module fan_speed_controller(
    input [7:0] temperature,
    output reg [1:0] fan_speed
);

always @(temperature) begin
    if (temperature < 20) begin
        fan_speed = 2'b00; // Low speed
    end else if (temperature >= 20 && temperature <= 30) begin
        fan_speed = 2'b01; // Medium speed
    end else begin
        fan_speed = 2'b10; // High speed
    end
end

endmodule