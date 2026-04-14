module top_module(
    input [31:0] a,
    input [31:0] b,
    output [63:0] result
);reg [31:0] a_low;
reg [31:0] a_high;
reg [31:0] b_low;
reg [31:0] b_high;

wire [31:0] a_b_low;
wire [31:0] a_b_mid_low;
wire [31:0] a_b_mid_high;
wire [31:0] a_b_high;

wire [63:0] result_low;
wire [63:0] result_mid;
wire [63:0] result_high;

assign a_low = a[15:0];
assign a_high = a[31:16];
assign b_low = b[15:0];
assign b_high = b[31:16];

// Compute all partial products
assign a_b_low = a_low * b_low;
assign a_b_mid_low = a_low * b_high;
assign a_b_mid_high = a_high * b_low;
assign a_b_high = a_high * b_high;

// Compute the final result
assign result_low = a_b_low;
assign result_mid = a_b_mid_low + a_b_mid_high;
assign result_high = a_b_high;

assign result = {result_high, result_mid[31:0], result_low};

endmodule