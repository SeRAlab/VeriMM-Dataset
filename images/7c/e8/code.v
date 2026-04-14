module mux_2to1(A, B, SEL, Y);
input [3:0] A, B;
input SEL;
output reg [3:0] Y;

always @(*) begin
    case (SEL)
        1'b0: Y = A;
        1'b1: Y = B;
        default: Y = 4'b0000;
    endcase
end

endmodule