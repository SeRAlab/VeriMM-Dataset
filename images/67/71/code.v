module top_module(
    input clk,
    input [WIDTH-1:0] data,
    input ce,
    input [ADDR_WIDTH-1:0] a,
    output reg [WIDTH-1:0] q
);parameter WIDTH = 8;
parameter ADDR_WIDTH = 2;
parameter DEPTH = 4;

reg [WIDTH-1:0] SRL_SIG [0:DEPTH-1];
integer i;

always @ (posedge clk)
begin
    if (ce)
    begin
        for (i=0; i<DEPTH-1; i=i+1)
            SRL_SIG[i+1] <= SRL_SIG[i];
        SRL_SIG[0] <= data;
    end
end

assign q = SRL_SIG[a];

endmodule