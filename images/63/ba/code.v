module top_module(
    input clk,
    input rce,
    input [10:0] ra,
    output reg [7:0] rq,
    input wce,
    input [10:0] wa,
    input [7:0] wd
);parameter AWIDTH = 11;
parameter DWIDTH = 8;

reg [7:0] mem [0:2047];

always @(posedge clk) begin
    if (rce) begin
        rq <= mem[ra];
    end
    if (wce) begin
        mem[wa] <= wd;
    end
end

endmodule