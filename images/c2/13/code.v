module mux4 (
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output reg Y
);

always @(*) begin
    case ({S1, S0})
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
    endcase
end

endmodule