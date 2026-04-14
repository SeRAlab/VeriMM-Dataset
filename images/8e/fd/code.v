module top_module(
    input [3:0] A,
    input [1:0] shift,
    input clk,          // Added input for clock
    output reg [3:0] out
);reg [3:0] stage1_out, stage2_out;

always @(*) begin
    case(shift)
        2'b00: stage1_out = A; // no shift
        2'b01: stage1_out = {A[2:0], A[3]}; // shift right by 1
        2'b10: stage1_out = {A[1:0], A[3:2]}; // shift left by 1
        2'b11: stage1_out = {A[0], A[3:1]}; // shift left by 2
        default: stage1_out = A; // default case to avoid latches
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign out = stage2_out;

endmodule