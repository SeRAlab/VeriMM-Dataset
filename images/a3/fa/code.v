module shift_register (
    input clk,
    input sclr,
    input shift_en,
    input data,
    output [3:0] q );reg [3:0] q_reg;

always @(posedge clk) begin
    if (sclr)
        q_reg <= 4'b0000;
    else if (shift_en)
        q_reg <= {q_reg[2:0], data};
end

assign q = q_reg;

endmodule