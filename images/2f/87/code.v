module mux3to1 (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [1:0] sel,
    output reg [7:0] Y
);
    always @(*) begin
        case (sel)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = 8'b00000000; // all bits low
            default: Y = 8'b00000000; // default case (should not happen)
        endcase
    end
endmodule