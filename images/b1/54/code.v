module top_module (
    input clk,
    input set_n,
    input si,
    output [3:0] q);reg [3:0] q_reg;

always @(posedge clk or negedge set_n) begin
    if (~set_n)
        q_reg <= 4'b1111;
    else
        q_reg <= {q_reg[2:0], si};
end

assign q = q_reg;

endmodule