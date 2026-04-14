module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input S0,
    input S1,
    output reg Y
);always @(*) begin
    case ({S1, S0})
        2'b00: Y = A1;
        2'b01: Y = A2;
        2'b10: Y = A3;
        2'b11: Y = A4;
    endcase
end

endmodule