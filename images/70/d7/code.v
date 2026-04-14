module top_module(
    input S1,
    input S0,
    input D3,
    input D2,
    input D1,
    input D0,
    output reg Y
);always @* begin
    case ({S1, S0})
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
    endcase
end

endmodule