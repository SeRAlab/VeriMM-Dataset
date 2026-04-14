module decoder (
    input A,
    input B,
    input C,
    output reg [7:0] Y
);

always @(*) begin
    case ({A,B,C})
        3'b000: Y = 8'b111_11110;
        3'b001: Y = 8'b111_11101;
        3'b010: Y = 8'b111_11011;
        3'b011: Y = 8'b111_10111;
        3'b100: Y = 8'b111_01111;
        3'b101: Y = 8'b110_11111;
        3'b110: Y = 8'b101_11111;
        3'b111: Y = 8'b011_11111;
    endcase
end

endmodule