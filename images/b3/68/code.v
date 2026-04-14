module top_module (
    input clk,
    input set_n,
    input d,
    output q);reg q_reg;

always @(posedge clk or negedge set_n) begin
    if (~set_n)
        q_reg <= 1'b1;
    else
        q_reg <= d;
end

assign q = q_reg;

endmodule