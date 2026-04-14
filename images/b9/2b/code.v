module bin_to_bcd (
    input [3:0] bin,
    output reg [7:0] bcd
);
    always @(*) begin
        bcd = 8'b00000000;
        case (bin)
            4'b0000: bcd = 8'b00000000;
            4'b0001: bcd = 8'b00000001;
            4'b0010: bcd = 8'b00000010;
            4'b0011: bcd = 8'b00000011;
            4'b0100: bcd = 8'b00000100;
            4'b0101: bcd = 8'b00000101;
            4'b0110: bcd = 8'b00000110;
            4'b0111: bcd = 8'b00000111;
            4'b1000: bcd = 8'b00001000;
            4'b1001: bcd = 8'b00001001;
            default: bcd = 8'b00000000;
        endcase
    end
endmodule