module fan_speed_control(
    input wire clk,
    input wire enable,
    input wire [7:0] temperature, // 8-bit temperature input
    output reg [1:0] fan_speed // 2-bit output: 00 = low, 01 = medium, 10 = high
);
    
    always @(posedge clk) begin
        if (enable) begin
            if (temperature < 20) begin
                fan_speed <= 2'b00; // low speed
            end else if (temperature >= 20 && temperature <= 30) begin
                fan_speed <= 2'b01; // medium speed
            end else begin
                fan_speed <= 2'b10; // high speed
            end
        end
    end
endmodule