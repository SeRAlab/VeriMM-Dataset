module top_module(
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1,
    output reg X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    always @*
    begin
        case ({S1, S0})
            2'b00: X = A0;
            2'b01: X = A1;
            2'b10: X = A2;
            2'b11: X = A3;
        endcase
    end

endmodule