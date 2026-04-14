module top_module(A, B, Y);parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 1;
parameter B_WIDTH = 1;
parameter Y_WIDTH = 1;

localparam WIDTH = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

wire [WIDTH-1:0] A_buf, B_buf, diff_buf;
wire [WIDTH-1:0] abs_diff_buf;

assign A_buf = (A_SIGNED) ? {{(WIDTH-A_WIDTH){A[A_WIDTH-1]}}, A} : {{(WIDTH-A_WIDTH){1'b0}}, A};
assign B_buf = (B_SIGNED) ? {{(WIDTH-B_WIDTH){B[B_WIDTH-1]}}, B} : {{(WIDTH-B_WIDTH){1'b0}}, B};

assign diff_buf = A_buf - B_buf;
assign abs_diff_buf = (diff_buf[WIDTH-1] == 1'b1) ? ~diff_buf + 1'b1 : diff_buf; // Two's complement for negative values
assign Y = |abs_diff_buf;

endmodule