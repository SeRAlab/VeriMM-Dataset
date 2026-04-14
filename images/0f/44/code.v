module hash_table (
    input [4:0] addr,
    output reg [2:0] data
);
    always @(*) begin
        case (addr)
            5'b00000: data = 3'b000;
            5'b00001: data = 3'b001;
            5'b00010: data = 3'b010;
            5'b00011: data = 3'b011;
            5'b00100: data = 3'b100;
            5'b00101: data = 3'b101;
            5'b00110: data = 3'b110;
            5'b00111: data = 3'b111;
            5'b01000: data = 3'b000;
            5'b01001: data = 3'b001;
            5'b01010: data = 3'b010;
            5'b01011: data = 3'b011;
            5'b01100: data = 3'b100;
            5'b01101: data = 3'b101;
            5'b01110: data = 3'b110;
            5'b01111: data = 3'b111;
            5'b10000: data = 3'b000;
            5'b10001: data = 3'b001;
            5'b10010: data = 3'b010;
            5'b10011: data = 3'b011;
            5'b10100: data = 3'b100;
            5'b10101: data = 3'b101;
            5'b10110: data = 3'b110;
            5'b10111: data = 3'b111;
            5'b11000: data = 3'b000;
            5'b11001: data = 3'b001;
            5'b11010: data = 3'b010;
            5'b11011: data = 3'b011;
            5'b11100: data = 3'b100;
            5'b11101: data = 3'b101;
            5'b11110: data = 3'b110;
            5'b11111: data = 3'b111;
            default: data = 3'b000;
        endcase
    end
endmodule