module top_module(
    input clk,           // Added clock input
    input [3:0] a,
    output reg [3:0] gray
);reg [3:0] a_reg;

always @ (posedge clk) begin
    a_reg <= a;
    gray <= {1'b0, a_reg[3:1]} ^ a_reg; // Direct assignment to output without intermediate reg
end

endmodule