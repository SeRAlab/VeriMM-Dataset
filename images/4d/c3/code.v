module shift_register_8bit(DATA_IN, SHIFT_LEFT, DATA_OUT);
input [7:0] DATA_IN;
input SHIFT_LEFT;
output reg [7:0] DATA_OUT;

always @(*) begin
    if (SHIFT_LEFT)
        DATA_OUT = DATA_IN << 1;
    else
        DATA_OUT = DATA_IN >> 1;
end

endmodule