module mux_8bit_2to1
(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output reg [7:0] y
);

always @(*) begin
    case (sel)
        1'b0: y = a;
        1'b1: y = b;
        default: y = 8'b00000000;
    endcase
end

endmodule