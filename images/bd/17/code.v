module binary_to_bcd (
        input [3:0] binary_in,
        output reg [4:0] bcd_out);

    always @(*) begin
        case (binary_in)
            4'b0000: bcd_out = 5'b00000;
            4'b0001: bcd_out = 5'b00001;
            4'b0010: bcd_out = 5'b00010;
            4'b0011: bcd_out = 5'b00011;
            4'b0100: bcd_out = 5'b00100;
            4'b0101: bcd_out = 5'b00101;
            4'b0110: bcd_out = 5'b00110;
            4'b0111: bcd_out = 5'b00111;
            4'b1000: bcd_out = 5'b01000;
            4'b1001: bcd_out = 5'b01001;
            default: bcd_out = 5'b11111; // Error case
        endcase
    end

endmodule