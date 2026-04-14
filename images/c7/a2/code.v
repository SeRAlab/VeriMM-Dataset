module mux4(input [3:0] A, B, C, D, input [1:0] S, output reg Y);

always @(*) begin
    case(S)
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
    endcase
end

endmodule