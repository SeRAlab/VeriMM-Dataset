module piso_shift_reg(CLK, LOAD, PARALLEL_IN, SERIAL_OUT);
input CLK, LOAD;
input [7:0] PARALLEL_IN;
output reg SERIAL_OUT;

reg [7:0] shift_reg;

always @(posedge CLK) begin
    if (LOAD)
        shift_reg <= PARALLEL_IN;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
    
    SERIAL_OUT <= shift_reg[7];
end

endmodule