module top_module(
    input [15:0] A,
    input [15:0] B,
    input [3:0] SHIFT,
    input clk,           // Added clk input
    output reg [15:0] S
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @(*) begin
    case (SHIFT)
        4'b0000: stage1_out = A;
        4'b0001: stage1_out = A << 1;
        4'b0010: stage1_out = A << 2;
        4'b0011: stage1_out = A << 3;
        4'b0100: stage1_out = A << 4;
        4'b0101: stage1_out = A << 5;
        4'b0110: stage1_out = A << 6;
        4'b0111: stage1_out = A << 7;
        4'b1000: stage1_out = A << 8;
        4'b1001: stage1_out = A << 9;
        4'b1010: stage1_out = A << 10;
        4'b1011: stage1_out = A << 11;
        4'b1100: stage1_out = A << 12;
        4'b1101: stage1_out = A << 13;
        4'b1110: stage1_out = A << 14;
        4'b1111: stage1_out = A << 15;
        default: stage1_out = A;
    endcase
end

always @(*) begin
    if (SHIFT[3] == 1) begin
        stage2_out = B >> 8;
    end else begin
        stage2_out = stage1_out;
    end
end

always @(posedge clk) begin
    S <= stage2_out;
end

endmodule