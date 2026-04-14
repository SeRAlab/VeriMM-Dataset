module piso_shift_register (CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [7:0] D;
output reg Q;
reg [7:0] shift_reg;

always @(posedge CLK or posedge RST) begin
    if (RST)
        shift_reg <= 8'b00000000;
    else if (LOAD)
        shift_reg <= D;
    else
        shift_reg <= shift_reg >> 1;
end

always @(*) begin
    Q = shift_reg[0];
end

endmodule