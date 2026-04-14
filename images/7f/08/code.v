module top_module(
    input clk,                  // Added clk input
    input [7:0] data_in,
    input [2:0] shift_amount,
    output [7:0] data_out
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Stage 1
always @(*) begin
    stage1_out = data_in;
end

// Stage 2
always @(posedge clk) begin
    stage2_out <= stage1_out << shift_amount;
end

// Output
assign data_out = stage2_out;

endmodule