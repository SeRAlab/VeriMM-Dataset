module top_module(
    input [3:0] data_in,
    output reg [7:0] bcd_out
);always @(*) begin
    case(data_in)
        4'b0000: bcd_out = 8'b00000001;
        4'b0001: bcd_out = 8'b00000010;
        4'b0010: bcd_out = 8'b00000100;
        4'b0011: bcd_out = 8'b00000110;
        4'b0100: bcd_out = 8'b00001000;
        4'b0101: bcd_out = 8'b00001001;
        4'b0110: bcd_out = 8'b00001100;
        4'b0111: bcd_out = 8'b00001110;
        4'b1000: bcd_out = 8'b00010000;
        4'b1001: bcd_out = 8'b00010001;
        default: bcd_out = 8'b00000000;
    endcase
end

endmodule