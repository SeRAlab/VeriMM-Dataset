module top_module(
    input [7:0] D,
    output [2:0] EN
);reg [2:0] EN_reg;

always @(*) begin
    EN_reg[2] = (D[7] && !D[6] && !D[5]);
    EN_reg[1] = (!D[7] && D[6] && !D[5]);
    EN_reg[0] = (!D[7] && !D[6] && D[5]);
end

assign EN = EN_reg;

endmodule