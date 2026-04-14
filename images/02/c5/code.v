module barrel_shifter (
    input [1:0] in,      // 2-bit input
    input shift,         // 1-bit shift control
    output reg [1:0] out // 2-bit output
);
    always @(*) begin
        case(shift)
            1'b0: out = in;                  // No shift
            1'b1: out = {in[0], in[1]};      // Shift left (wrap around)
            default: out = 2'b00;            // Default case
        endcase
    end
endmodule