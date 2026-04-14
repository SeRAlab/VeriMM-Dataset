module shift_reg_4bit (D, CLK, LOAD, Q);
input [3:0] D;
input CLK, LOAD;
output Q;
reg [3:0] shift_reg;

always @(posedge CLK) begin
    if (LOAD)
        shift_reg <= D;
    else
        shift_reg <= {1'b0, shift_reg[3:1]};
end

assign Q = shift_reg[0];

endmodule