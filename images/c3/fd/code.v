module mux4to1(
    input [3:0] A0,
    input [3:0] A1,
    input [3:0] A2,
    input [3:0] A3,
    input S0,
    input S1,
    input VPWR,
    input VGND,
    output reg Y
);

    always @ (S1 or S0 or A0 or A1 or A2 or A3) begin
        case ({S1, S0})
            2'b00: Y <= A0;
            2'b01: Y <= A1;
            2'b10: Y <= A2;
            2'b11: Y <= A3;
        endcase
    end

endmodule