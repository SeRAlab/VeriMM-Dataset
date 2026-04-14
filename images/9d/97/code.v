module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output rise,
    output down,
    output [1:0] state
);reg [31:0] in_reg;
reg [31:0] in_delayed;
reg [31:0] in_delayed2;
wire rising_edge;
wire falling_edge;

assign rising_edge = in_delayed & ~in_delayed2;
assign falling_edge = ~in_delayed & in_delayed2;

assign rise = rising_edge;
assign down = falling_edge;

assign state = {in_delayed2, rising_edge | falling_edge};

always @(posedge clk) begin
    if (reset) begin
        in_reg <= 0;
        in_delayed <= 0;
        in_delayed2 <= 0;
    end else begin
        in_reg <= in;
        in_delayed <= in_reg;
        in_delayed2 <= in_delayed;
    end
end

endmodule