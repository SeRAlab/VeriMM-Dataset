module mux2to1 (
    input [4:0] a,
    input [4:0] b,
    input sel,
    output reg [4:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 5'b00000; // default case
    endcase
end

endmodule