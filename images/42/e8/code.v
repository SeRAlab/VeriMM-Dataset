module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] C,
    input clk,          // Added clk input
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(C)
        2: stage1_out = A ^ B;
        1: stage1_out = B;
        default: stage1_out = A;
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out; // Use non-blocking assignment for sequential logic
end

assign out = stage2_out;

endmodule