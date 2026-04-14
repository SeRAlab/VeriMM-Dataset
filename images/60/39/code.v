module top_module(dout, clk, din);parameter upper=0, lower=0; 
parameter width = upper - lower + 1;

output [upper:lower] dout;  
input                clk;   
input  [upper:lower] din;   

reg    [upper:lower] dout_pre;
wire   [upper:lower] dout;











always @*
    if (~clk) 
        dout_pre[upper:lower] <= din[upper:lower];

assign dout[upper:lower] = dout_pre[upper:lower];








endmodule