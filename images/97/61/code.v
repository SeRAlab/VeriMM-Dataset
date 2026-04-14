module top_module(din, rst, en, clk, q, se, si, so);parameter SIZE = 1;

input	[SIZE-1:0]	din ;	// data in
input			en ;	// functional enable
input			rst ;	// reset
input			clk ;	// clk or scan clk

output	[SIZE-1:0]	q ;	// output

input			se ;	// scan-enable
input	[SIZE-1:0]	si ;	// scan-input
output	[SIZE-1:0]	so ;	// scan-output

reg 	[SIZE-1:0]	q ;

always @ (posedge clk)
begin
    if (se == 1'b1) // if scan-enable is high, use scan-input
        q <= si;
    else if (rst == 1'b1) // if reset is high, reset output to 0
        q <= 1'b0;
    else if (en == 1'b1) // if enable is high, use data input
        q <= din;
end

assign so = q;

endmodule