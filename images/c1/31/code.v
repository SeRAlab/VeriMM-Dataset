module	tlu_addern_32 (din, incr, sum);
parameter ADDER_DATA_WIDTH = 33;
parameter INCR_DATA_WIDTH  =  1;
parameter UPPER_DATA_WIDTH =  ADDER_DATA_WIDTH - INCR_DATA_WIDTH;
input	[ADDER_DATA_WIDTH-1:0]	din;
input	[INCR_DATA_WIDTH-1:0]   incr;
output	[ADDER_DATA_WIDTH-1:0]	sum;
assign	sum[ADDER_DATA_WIDTH-1:0] =
            din[ADDER_DATA_WIDTH-1:0] + {{UPPER_DATA_WIDTH{1'b0}},incr[INCR_DATA_WIDTH-1:0]};
endmodule