module top_module(
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo,
    input [254:0] in_tree,
    output [7:0] out_tree,
    output reg [15:0] out_sum,
    input clk  // Added clk input here
);// Barrel shifter
assign out_hi = in[15:8];
assign out_lo = in[7:0];

// Binary tree adder
assign out_tree = $countones(in_tree);

// Functional module
always @ (posedge clk) begin
    if (out_hi !== 0 && out_tree !== 0) begin
        out_sum <= out_hi + out_tree;
    end
end

endmodule