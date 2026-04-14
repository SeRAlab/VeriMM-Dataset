module piso_shift_register (CLK, RESET, LOAD, DATA_IN, DATA_OUT);
input CLK;
input RESET;
input LOAD;
input [7:0] DATA_IN;
output reg DATA_OUT;
reg [7:0] shift_reg;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        shift_reg <= 8'b00000000;
        DATA_OUT <= 1'b0;
    end
    else if (LOAD) begin
        shift_reg <= DATA_IN;
    end
    else begin
        DATA_OUT <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
    end
end

endmodule