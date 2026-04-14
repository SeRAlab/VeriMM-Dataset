module fan_speed_control(
    input [5:0] temperature,
    output reg [1:0] fan_speed
);
    always @(*) begin
        if (temperature <= 20) begin
            fan_speed = 2'b00; // Low speed
        end else if (temperature >= 21 && temperature <= 30) begin
            fan_speed = 2'b01; // Medium speed
        end else begin
            fan_speed = 2'b10; // High speed
        end
    end
endmodule