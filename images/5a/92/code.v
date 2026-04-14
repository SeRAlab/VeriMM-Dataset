module mux_2to1_8bit (A, B, SEL, Y);
input [7:0] A, B;
input SEL;
output reg [7:0] Y;

always @(*) begin
    case (SEL)
        1'b0: Y = A;
        1'b1: Y = B;
        default: Y = 8'b0;
    endcase
end

endmodule