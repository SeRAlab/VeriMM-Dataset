module mux_2to1(IN0, IN1, SEL, OUT);
input [3:0] IN0, IN1;
input SEL;
output reg [3:0] OUT;

always @(*) begin
    case (SEL)
        1'b0: OUT = IN0;
        1'b1: OUT = IN1;
        default: OUT = 4'b0000;
    endcase
end

endmodule