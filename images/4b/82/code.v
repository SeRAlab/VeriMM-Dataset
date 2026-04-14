module top_module(
    input [3:0] A,
    input [3:0] B,
    input DIR,
    input [1:0] AMT,
    input clk,
    output reg [3:0] S
);reg [3:0] stage1_out;

always @(*) begin
    case (AMT)
        2'b00: stage1_out = (DIR) ? A : B; // No shift
        2'b01: stage1_out = (DIR) ? {A[2:0], 1'b0} : {1'b0, A[3:1]}; // Shift by 1
        2'b10: stage1_out = (DIR) ? {A[1:0], 2'b00} : {2'b00, A[3:2]}; // Shift by 2
        2'b11: stage1_out = (DIR) ? {A[0], 3'b000} : {3'b000, A[3]}; // Shift by 3
        default: stage1_out = A; // Should not reach here
    endcase
end

always @(posedge clk) begin
    S <= stage1_out;
end

endmodule