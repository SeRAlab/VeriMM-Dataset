module top_module(din, clk, rst, q, se, si, so);parameter SIZE = 1;

input	[SIZE-1:0]	din ;	// data in
input			clk ;	// clk or scan clk
input			rst ;	// reset

output	[SIZE-1:0]	q ;	// output

input			se ;	// scan-enable
input	[SIZE-1:0]	si ;	// scan-input
output	[SIZE-1:0]	so ;	// scan-output

reg 	[SIZE-1:0]	q ;

always @ (posedge clk)
	if (se) begin
		q[SIZE-1:0] <= si[SIZE-1:0];
	end else begin
		if (rst) begin
			q[SIZE-1:0] <= {SIZE{1'b0}};
		end else begin
			q[SIZE-1:0] <= din[SIZE-1:0];
		end
	end

assign so[SIZE-1:0] = q[SIZE-1:0] ;

endmodule