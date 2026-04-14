module bin_to_one_hot(BIN_IN, ONE_HOT_OUT);
input [1:0] BIN_IN;
output reg [3:0] ONE_HOT_OUT;

always @(*) begin
    case (BIN_IN)
        2'b00: ONE_HOT_OUT = 4'b0001;
        2'b01: ONE_HOT_OUT = 4'b0010;
        2'b10: ONE_HOT_OUT = 4'b0100;
        2'b11: ONE_HOT_OUT = 4'b1000;
        default: ONE_HOT_OUT = 4'b0000;
    endcase
end

endmodule