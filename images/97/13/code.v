module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] out
);reg [7:0] prev_in;

always @(posedge clk) begin
    out <= (in & ~prev_in);
    prev_in <= in;
end

endmodule