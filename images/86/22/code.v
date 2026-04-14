module top_module(
    input clk,
    input enable,
    input [3:0] val,
    input [2:0] sidx,
    output reg [7:0] digit,
    output reg [7:0] segment
);always @(posedge clk) begin
    if (enable) begin
        case (sidx)
            3'd0: digit <= 8'b11111110;
            3'd1: digit <= 8'b11111101;
            3'd2: digit <= 8'b11111011;
            3'd3: digit <= 8'b11110111;
            default: digit <= 8'b11111111;
        endcase

        case (val)
            4'b0000: segment <= 8'b00111111; // 0
            4'b0001: segment <= 8'b00000110; // 1
            4'b0010: segment <= 8'b01011011; // 2
            4'b0011: segment <= 8'b01001111; // 3
            4'b0100: segment <= 8'b01100110; // 4
            4'b0101: segment <= 8'b01101101; // 5
            4'b0110: segment <= 8'b01111101; // 6
            4'b0111: segment <= 8'b00000111; // 7
            4'b1000: segment <= 8'b01111111; // 8
            4'b1001: segment <= 8'b01101111; // 9
            4'b1010: segment <= 8'b01110111; // A
            default: segment <= 8'b10000000; // Blank
        endcase
    end else begin
        digit <= 8'b11111111;
        segment <= 8'b11111111;
    end
end

endmodule