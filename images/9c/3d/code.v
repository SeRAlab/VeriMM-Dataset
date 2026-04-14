module decoder_3to8(
    input  [2:0] a,
    output [7:0] y
);

reg [7:0] y_reg;

always @(*) begin
    case (a)
        3'b000: y_reg = 8'b00000001;
        3'b001: y_reg = 8'b00000010;
        3'b010: y_reg = 8'b00000100;
        3'b011: y_reg = 8'b00001000;
        3'b100: y_reg = 8'b00010000;
        3'b101: y_reg = 8'b00100000;
        3'b110: y_reg = 8'b01000000;
        3'b111: y_reg = 8'b10000000;
        default: y_reg = 8'b00000000;
    endcase
end

assign y = y_reg;

endmodule