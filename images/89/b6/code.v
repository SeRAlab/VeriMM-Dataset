module mux_4to1_8bit(A, B, C, D, sel, Y);
    input [7:0] A, B, C, D;
    input [1:0] sel;
    output reg [7:0] Y;

    always @(*) begin
        case (sel)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
            default: Y = 8'b0;
        endcase
    end
endmodule