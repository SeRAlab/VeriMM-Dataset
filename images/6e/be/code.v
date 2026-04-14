module mux_4to1(
    input [7:0] in0,   // First 8-bit input signal.
    input [7:0] in1,   // Second 8-bit input signal.
    input [7:0] in2,   // Third 8-bit input signal.
    input [7:0] in3,   // Fourth 8-bit input signal.
    input [1:0] sel,   // 2-bit select signal.

    output reg [7:0] out // 8-bit output signal.
);

always @(*) begin
    case (sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 8'h00;
    endcase
end

endmodule