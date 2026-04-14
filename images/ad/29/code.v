module top_module(
    D0,
    D1,
    D2,
    D3,
    S0,
    S1,
    X,
    VPWR,
    VGND
);output reg X;
    input  D0, D1, D2, D3;
    input  S0, S1;
    input  VPWR, VGND;

    // The multiplexer logic is defined here directly
    always @(*) begin
        case ({S1, S0})
            2'b00: X = D0; // when S1 S0 = 00, output D0
            2'b01: X = D1; // when S1 S0 = 01, output D1
            2'b10: X = D2; // when S1 S0 = 10, output D2
            2'b11: X = D3; // when S1 S0 = 11, output D3
            default: X = 1'b0; // default case to avoid latches
        endcase
    end
    
endmodule