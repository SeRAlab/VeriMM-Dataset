module top_module (
    input clk,
    input reset_n,
    input d,
    output q,
    output q_bar);reg q_reg;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        q_reg <= 1'b0;
    else
        q_reg <= d;
end

assign q = q_reg;
assign q_bar = ~q_reg;

endmodule