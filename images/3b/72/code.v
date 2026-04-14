module fan_speed_control (
    input wire clk,
    input wire [1:0] control, // 00: Off, 01: Low, 10: Medium, 11: High
    input wire [7:0] temperature, // 0 to 255 degrees
    output reg [1:0] speed // 00: Off, 01: Low, 10: Medium, 11: High
);
    always @(posedge clk) begin
        if (control == 2'b00) begin
            speed <= 2'b00; // Off
        end else begin
            if (temperature < 20) begin
                speed <= 2'b00; // Off
            end else if (temperature >= 20 && temperature < 30) begin
                speed <= 2'b01; // Low
            end else if (temperature >= 30 && temperature < 40) begin
                speed <= 2'b10; // Medium
            end else begin
                speed <= 2'b11; // High
            end
        end
    end
endmodule