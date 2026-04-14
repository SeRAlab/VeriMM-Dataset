module top_module(
    clk,
    data,
    ce,
    a,
    shift,
    q);parameter DATA_WIDTH = 12;
parameter ADDR_WIDTH = 2;
parameter DEPTH = 3;

input clk;
input [DATA_WIDTH-1:0] data;
input ce;
input [ADDR_WIDTH-1:0] a;
input [ADDR_WIDTH-1:0] shift;
output [DATA_WIDTH-1:0] q;

reg[DATA_WIDTH-1:0] SRL_SIG [0:DEPTH-1];
integer i;

always @ (posedge clk)
    begin
        if (ce)
        begin
            for (i=0;i<DEPTH-1;i=i+1)
                SRL_SIG[i+1] <= SRL_SIG[i];
            SRL_SIG[0] <= data;
        end
        else
        begin
            for (i=DEPTH-2;i>=0;i=i-1)
                SRL_SIG[i] <= SRL_SIG[i+1];
            SRL_SIG[DEPTH-1] <= 0;
        end
    end

assign q = SRL_SIG[a];

endmodule