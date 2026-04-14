module top_module(rst, clk, test, sync, freq, o);parameter WID = 32; 
input rst;
input clk;
input test;
input sync;
input [WID-1:0] freq;   
output [WID-1:0] o;

reg [WID-1:0] acc;

always @(posedge clk)
if (rst)
    acc <= 0;
else begin
    if (~test) begin
        if (sync)
            acc <= 0;
        else
            acc <= acc + freq;
    end
    else
        acc <= 0;
end

assign o = acc;

endmodule