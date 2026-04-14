module piso_shift_register(CLK, RST, LD, Parallel_in, Serial_out);
input CLK, RST, LD;
input [7:0] Parallel_in;
output Serial_out;
reg [7:0] shift_reg;
assign Serial_out = shift_reg[0];

always@(posedge CLK or posedge RST) begin
    if (RST)
        shift_reg <= 8'b00000000;
    else if (LD)
        shift_reg <= Parallel_in;
    else
        shift_reg <= shift_reg >> 1;
end

endmodule