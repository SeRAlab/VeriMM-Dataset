module fan_speed_control (
    input clk,
    input rst,
    input [3:0] temp,
    output reg [1:0] fan_speed // 00: LOW, 01: MEDIUM, 10: HIGH
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Initialize to LOW
        end else begin
            if (temp <= 4'b0110) begin
                fan_speed <= 2'b00; // LOW
            end else if (temp <= 4'b1100) begin
                fan_speed <= 2'b01; // MEDIUM
            end else begin
                fan_speed <= 2'b10; // HIGH
            end
        end
    end
endmodule