module top_module(
    input clk,
    input rce,
    input [9:0] ra,
    input wce,
    input [9:0] wa,
    input [15:0] wd,
    output [15:0] rq
);reg [15:0] memory [0:15];

always @(posedge clk) begin
    if (wce) begin
        memory[wa] <= wd;
    end
end

assign rq = (rce) ? memory[ra] : 16'b0;

endmodule