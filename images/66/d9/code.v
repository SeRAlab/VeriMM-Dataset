module shift_register(CLK, RST, LOAD, PARALLEL_IN, SERIAL_OUT);
input CLK, RST, LOAD;
input [7:0] PARALLEL_IN;
output SERIAL_OUT;
reg [7:0] shift_reg;
assign SERIAL_OUT = shift_reg[7];

always @(posedge CLK or posedge RST) begin
    if (RST)
        shift_reg <= 0;
    else if (LOAD)
        shift_reg <= PARALLEL_IN;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
end

endmodule