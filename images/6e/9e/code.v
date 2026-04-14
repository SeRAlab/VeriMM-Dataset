module binary_to_bcd (
    input [3:0] binary_in,
    output reg [7:0] bcd_out);always @(*) begin
        case (binary_in)
            4'd0: bcd_out = 8'b00000000;
            4'd1: bcd_out = 8'b00000001;
            4'd2: bcd_out = 8'b00000010;
            4'd3: bcd_out = 8'b00000011;
            4'd4: bcd_out = 8'b00000100;
            4'd5: bcd_out = 8'b00000101;
            4'd6: bcd_out = 8'b00000110;
            4'd7: bcd_out = 8'b00000111;
            4'd8: bcd_out = 8'b00001000;
            4'd9: bcd_out = 8'b00001001;
            4'd10: bcd_out = 8'b00010000;
            4'd11: bcd_out = 8'b00010001;
            4'd12: bcd_out = 8'b00010010;
            4'd13: bcd_out = 8'b00010011;
            4'd14: bcd_out = 8'b00010100;
            4'd15: bcd_out = 8'b00010101;
            default: bcd_out = 8'b00000000;
        endcase
    end

endmodule