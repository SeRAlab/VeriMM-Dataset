module shift_register (
    input clk,
    input sreset,
    input load_enable,
    input shift,
    input [23:0] data,
    output [23:0] q );reg [23:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 24'b0;
    else if (load_enable)
        q_reg <= data;
    else if (shift)
        q_reg <= {q_reg[22:0], 1'b0};
end

assign q = q_reg;

endmodule