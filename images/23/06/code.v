module fan_speed_control(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg [2:0] fan_speed
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 3'b000; // off
        end else begin
            if (temperature < 20) begin
                fan_speed <= 3'b000; // off
            end else if (temperature < 40) begin
                fan_speed <= 3'b001; // low
            end else if (temperature < 60) begin
                fan_speed <= 3'b010; // medium
            end else if (temperature < 80) begin
                fan_speed <= 3'b011; // high
            end else begin
                fan_speed <= 3'b100; // very high
            end
        end
    end
endmodule