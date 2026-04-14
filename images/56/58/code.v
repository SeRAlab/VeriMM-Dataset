module top_module(
    input clk,
    input reset,            // Asynchronous reset
    input [3:0] d,
    input enable,
    output [3:0] q
);reg [3:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 4'b0000;
    end else if (enable) begin
        q_reg <= {q_reg[2:0], d};
    end
end

assign q = q_reg;

endmodule