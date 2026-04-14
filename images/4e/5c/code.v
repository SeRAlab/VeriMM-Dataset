module top_module(
    input [15:0] input16,
    output [7:0] output8
);wire [7:0] first8;
wire [7:0] last8;

assign first8 = input16[15:8];
assign last8 = input16[7:0];

// ripple carry adder
wire [8:0] sum;
assign sum = {1'b0, first8} + {1'b0, last8};

assign output8 = sum[7:0];

endmodule