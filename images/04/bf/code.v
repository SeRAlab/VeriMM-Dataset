module mux3to1 (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [1:0] sel,
    output reg [3:0] Y
);
    always @(*) begin
        case(sel)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            default: Y = 4'bxxxx; // Undefined output
        endcase
    end
endmodule