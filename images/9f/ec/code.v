module top_module(
    input [3:0] A0,
    input [3:0] A1,
    input [3:0] A2,
    input [3:0] A3,
    input S0,
    input S1,
    output reg [3:0] X
);always @* begin
    case ({S1, S0})
        2'b00: X = A0;
        2'b01: X = A1;
        2'b10: X = A2;
        2'b11: X = A3;
    endcase
end

endmodule