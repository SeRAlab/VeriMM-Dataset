module top_module(A, B, Y);parameter WIDTH = 8;
input [WIDTH-1:0] A, B;
output [WIDTH-1:0] Y;

wire [WIDTH*WIDTH-1:0] partials;

genvar i;
assign partials[WIDTH-1 : 0] = A[0] ? B : 0;
generate for (i = 1; i < WIDTH; i = i+1) begin:gen
	assign partials[WIDTH*(i+1)-1 : WIDTH*i] = (A[i] ? B << i : 0) + partials[WIDTH*i-1 : WIDTH*(i-1)];
end endgenerate

assign Y = partials[WIDTH*WIDTH-1 : WIDTH*(WIDTH-1)];

endmodule