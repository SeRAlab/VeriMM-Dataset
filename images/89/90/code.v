module top_module(
    input clk,          // Added clk as an input
    input [3:0] BCD,
    output reg [6:0] SEG
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @ (posedge clk) begin
    stage1_out <= BCD;
end

always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

always @ (posedge clk) begin
    case(stage2_out)
        4'b0000: SEG <= 7'b1000000; // 0
        4'b0001: SEG <= 7'b1111001; // 1
        4'b0010: SEG <= 7'b0100100; // 2
        4'b0011: SEG <= 7'b0110000; // 3
        4'b0100: SEG <= 7'b0011001; // 4
        4'b0101: SEG <= 7'b0010010; // 5
        4'b0110: SEG <= 7'b0000010; // 6
        4'b0111: SEG <= 7'b1111000; // 7
        4'b1000: SEG <= 7'b0000000; // 8
        4'b1001: SEG <= 7'b0010000; // 9
        default: SEG <= 7'b1111111; // invalid input
    endcase
end

endmodule