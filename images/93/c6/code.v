module top_module (
    input clk,
    input load,
    input [3:0] d,
    output [3:0] q);reg [3:0] q_reg;

always @(posedge clk) begin
    if (load)
        q_reg <= d;
    else
        q_reg <= q_reg + 1;
end

assign q = q_reg;

endmodule