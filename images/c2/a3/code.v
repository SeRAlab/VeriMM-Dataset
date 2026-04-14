module alu(
    input [31:0] A, B, 
    input [2:0] F, 
    output reg [31:0] Y, 
    output reg Zero
);

always @*
begin
    case(F)
        3'b000: Y <= A & B;
        3'b001: Y <= A | B;
        3'b010: Y <= A + B;
        3'b011: Y <= A & ~B;
        3'b101: Y <= A + ~B;
        3'b110: Y <= A - B;
        3'b111: Y <= (A < B) ? 1 : 0;
        default: Y <= 0;
    endcase
    Zero <= (Y == 0) ? 1 : 0;
end

endmodule