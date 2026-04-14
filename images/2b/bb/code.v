module mux4to1 (
    input wire d0,
    input wire d1,
    input wire d2,
    input wire d3,
    input wire s0,
    input wire s1,
    output wire y
);
    assign y = (s0 == 0 && s1 == 0) ? d0 :
               (s0 == 0 && s1 == 1) ? d1 :
               (s0 == 1 && s1 == 0) ? d2 :
               (s0 == 1 && s1 == 1) ? d3 : 1'bz; // High impedance as a default case
endmodule