module binary_to_7segment (
    input [2:0] a,
    output reg [6:0] seg
);

    always @(*) begin
        case (a)
            3'b000: seg = 7'b1111110;
            3'b001: seg = 7'b0110000;
            3'b010: seg = 7'b1101101;
            3'b011: seg = 7'b1111001;
            3'b100: seg = 7'b0110011;
            3'b101: seg = 7'b1011011;
            3'b110: seg = 7'b1011111;
            3'b111: seg = 7'b1110000;
            default: seg = 7'b0000000;
        endcase
    end

endmodule