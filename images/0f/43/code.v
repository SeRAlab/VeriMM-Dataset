module phase_shifter(
    input [2:0] in,
    output reg [4:0] out
);
    always @(*) begin
        case(in)
            3'b000: out = 5'b00000;
            3'b001: out = 5'b00001;
            3'b010: out = 5'b00010;
            3'b011: out = 5'b00011;
            3'b100: out = 5'b00100;
            3'b101: out = 5'b00101;
            3'b110: out = 5'b00110;
            3'b111: out = 5'b00111;
            default: out = 5'b00000; // Default case
        endcase
    end
endmodule