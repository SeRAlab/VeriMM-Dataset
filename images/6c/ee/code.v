module multiplexer_4to1(A, sel, Y);
    input [3:0] A;
    input [1:0] sel;
    output reg Y;

    always @(*) begin
        case (sel)
            2'b00: Y = A[0];
            2'b01: Y = A[1];
            2'b10: Y = A[2];
            2'b11: Y = A[3];
            default: Y = 1'b0;
        endcase
    end
endmodule