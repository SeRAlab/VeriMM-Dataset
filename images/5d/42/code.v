module top_module(
    input [3:0] in,
    input [1:0] shift,
    input clk,              // Add clk input
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    case(shift)
        2'b00: stage1_out = in << 1; // logical left shift
        2'b01: stage1_out = in >> 1; // logical right shift
        2'b10: stage1_out = {in[1:0], in[3:2]}; // logical left shift
        2'b11: stage1_out = {in[0], in[3:1]}; // logical right shift
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign out = stage2_out;

endmodule