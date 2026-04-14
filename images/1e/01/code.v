module fan_speed_control (
    input wire clk,
    input wire reset,
    input wire [3:0] temperature,
    output reg [1:0] fan_speed
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fan_speed <= 2'b00; // Low speed
    end else begin
        if (temperature < 4'd20) begin
            fan_speed <= 2'b00; // Low speed
        end else if (temperature >= 4'd20 && temperature < 4'd30) begin
            fan_speed <= 2'b01; // Medium speed
        end else begin
            fan_speed <= 2'b10; // High speed
        end
    end
end

endmodule