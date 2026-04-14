module top_module(
    input [3:0] D,
    input LD, CLK, CLR, CA, SEL,
    output reg a, b, c, d, e, f, g
);reg [3:0] shift_reg;
reg [6:0] seven_seg_out;

always @(posedge CLK) begin
    if (CLR) begin
        shift_reg <= 4'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], D};
    end
end

always @(*) begin
    case (shift_reg[3:0])
        4'b0000: seven_seg_out = 7'b111_1110; // 0
        4'b0001: seven_seg_out = 7'b011_0000; // 1
        4'b0010: seven_seg_out = 7'b110_1101; // 2
        4'b0011: seven_seg_out = 7'b111_1001; // 3
        4'b0100: seven_seg_out = 7'b011_0011; // 4
        4'b0101: seven_seg_out = 7'b101_1011; // 5
        4'b0110: seven_seg_out = 7'b101_1111; // 6
        4'b0111: seven_seg_out = 7'b111_0000; // 7
        4'b1000: seven_seg_out = 7'b111_1111; // 8
        4'b1001: seven_seg_out = 7'b111_0011; // 9
        4'b1010: seven_seg_out = 7'b111_0111; // A
        4'b1011: seven_seg_out = 7'b001_1111; // B
        4'b1100: seven_seg_out = 7'b100_1110; // C
        4'b1101: seven_seg_out = 7'b011_1101; // D
        4'b1110: seven_seg_out = 7'b100_1111; // E
        4'b1111: seven_seg_out = 7'b100_0111; // F
    endcase
end

always @(*) begin
    case (SEL)
        2'b00: seven_seg_out = seven_seg_out[6:0];
        2'b01: seven_seg_out = seven_seg_out[5:0];
        2'b10: seven_seg_out = seven_seg_out[4:0];
        2'b11: seven_seg_out = seven_seg_out[3:0];
    endcase
end

always @(*) begin
    if (CA) begin
        a = ~seven_seg_out[0];
        b = ~seven_seg_out[1];
        c = ~seven_seg_out[2];
        d = ~seven_seg_out[3];
        e = ~seven_seg_out[4];
        f = ~seven_seg_out[5];
        g = ~seven_seg_out[6];
    end else begin
        a = seven_seg_out[0];
        b = seven_seg_out[1];
        c = seven_seg_out[2];
        d = seven_seg_out[3];
        e = seven_seg_out[4];
        f = seven_seg_out[5];
        g = seven_seg_out[6];
    end
end

endmodule