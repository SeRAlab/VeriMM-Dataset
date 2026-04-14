module top_module (
    input clk,
    input clear,
    input [3:0] d,
    output [3:0] q);reg [3:0] q_reg;

always @(posedge clk) begin
    if (clear)
        q_reg <= 4'b0;
    else
        q_reg <= d;
end

assign q = q_reg;

endmodule