module bin_to_bcd(
    input       [3:0]   bin_in      ,
 
    output  reg [7:0]   bcd_out
);

    always @(*) begin
        case (bin_in)
            4'b0000: bcd_out = 8'b0000_0000;
            4'b0001: bcd_out = 8'b0000_0001;
            4'b0010: bcd_out = 8'b0000_0010;
            4'b0011: bcd_out = 8'b0000_0011;
            4'b0100: bcd_out = 8'b0000_0100;
            4'b0101: bcd_out = 8'b0000_0101;
            4'b0110: bcd_out = 8'b0000_0110;
            4'b0111: bcd_out = 8'b0000_0111;
            4'b1000: bcd_out = 8'b0000_1000;
            4'b1001: bcd_out = 8'b0000_1001;
            4'b1010: bcd_out = 8'b0001_0000;
            4'b1011: bcd_out = 8'b0001_0001;
            4'b1100: bcd_out = 8'b0001_0010;
            4'b1101: bcd_out = 8'b0001_0011;
            4'b1110: bcd_out = 8'b0001_0100;
            4'b1111: bcd_out = 8'b0001_0101;
            default: bcd_out = 8'b0000_0000;
        endcase
    end

endmodule