module top_module(din, clk, rst, q);parameter SIZE = 1;

input	[SIZE-1:0]	din ;	// data in
input			clk ;	// clk
input			rst ;	// reset

output	[SIZE-1:0]	q ;	// output

reg 	[SIZE-1:0]	q ;

always @ (posedge clk or posedge rst)
begin
    if (rst)
        q <= 1'b0;
    else
        q <= din;
end

endmodule