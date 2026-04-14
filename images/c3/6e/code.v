module decoder_4to16 (
    input [1:0] A, B,
    input EN,
    output reg [15:0] Y
);

always @ (A or B or EN) begin
    case ({A,B})
        2'b00: Y = EN ? 16'b1111111111111110 : 16'b1111111111111111;
        2'b01: Y = EN ? 16'b1111111111111101 : 16'b1111111111111111;
        2'b10: Y = EN ? 16'b1111111111111011 : 16'b1111111111111111;
        2'b11: Y = EN ? 16'b1111111111110111 : 16'b1111111111111111;
        default: Y = 16'b1111111111111111;
    endcase
end

endmodule