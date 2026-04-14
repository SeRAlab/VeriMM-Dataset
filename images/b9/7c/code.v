module top_module(
    clk,
    data,
    ce,
    a,
    q
);parameter DATA_WIDTH = 12;
parameter ADDR_WIDTH = 2;
parameter DEPTH = 3;

input clk;
input [DATA_WIDTH-1:0] data;
input ce;
input [ADDR_WIDTH-1:0] a;
output [DATA_WIDTH-1:0] q;

reg [DATA_WIDTH-1:0] buffer [0:DEPTH-1];
integer i;

always @(posedge clk) begin
    if (ce) begin
        for (i = DEPTH-1; i > 0; i = i - 1) begin
            buffer[i] <= buffer[i-1];
        end
        buffer[0] <= data;
    end
end

assign q = buffer[a];

endmodule