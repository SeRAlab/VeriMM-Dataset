module mux4to1 (
    input I0,
    input I1,
    input I2,
    input I3,
    input S0,
    input S1,
    output Y
);
    assign Y = (S0 == 0 && S1 == 0) ? I0 :
               (S0 == 0 && S1 == 1) ? I1 :
               (S0 == 1 && S1 == 0) ? I2 :
               (S0 == 1 && S1 == 1) ? I3 : 1'b0;
endmodule