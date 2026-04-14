module fan_speed_controller(
    input wire clk,
    input wire [7:0] temperature, // 0 to 255 degrees Celsius
    output reg [1:0] fan_speed // 0: off, 1: low, 2: medium, 3: high
);

always @(posedge clk) begin
    if (temperature < 20) begin
        fan_speed <= 2'b00; // Off
    end else if (temperature >= 20 && temperature < 30) begin
        fan_speed <= 2'b01; // Low
    end else if (temperature >= 30 && temperature < 40) begin
        fan_speed <= 2'b10; // Medium
    end else begin
        fan_speed <= 2'b11; // High
    end
end

endmodule