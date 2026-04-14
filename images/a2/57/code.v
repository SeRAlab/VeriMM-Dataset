module top_module(code,rd_enable,clock, BCD);output [7:0]BCD;

input [3:0]code;
input rd_enable;
input clock;

reg [7:0]BCD;

always @(posedge clock )
begin
    if (rd_enable) begin
        case (code)
        4'b0000: BCD = 8'b00000000;
        4'b0001: BCD = 8'b00000001;
        4'b0010: BCD = 8'b00000010;
        4'b0011: BCD = 8'b00000011;
        4'b0100: BCD = 8'b00000100;
        4'b0101: BCD = 8'b00000101;
        4'b0110: BCD = 8'b00000110;
        4'b0111: BCD = 8'b00000111;
        4'b1000: BCD = 8'b00001000;
        4'b1001: BCD = 8'b00001001;
        4'b1010: BCD = 8'b00010000;
        4'b1011: BCD = 8'b00010001;
        4'b1100: BCD = 8'b00010010;
        4'b1101: BCD = 8'b00010011;
        4'b1110: BCD = 8'b00010100;
        4'b1111: BCD = 8'b00010101;
    endcase
    end
end

endmodule