module fan_speed_control (
    input [6:0] temperature,
    output reg [1:0] fan_speed
);

    always @(temperature) begin
        if (temperature < 7'd20) begin
            fan_speed <= 2'b01; // Low speed
        end else if (temperature >= 7'd20 && temperature <= 7'd30) begin
            fan_speed <= 2'b10; // Medium speed
        end else begin
            fan_speed <= 2'b11; // High speed
        end
    end
endmodule