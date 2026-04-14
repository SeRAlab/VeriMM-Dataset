module mux16to1 (
    input wire [3:0] sel,
    input wire [15:0] d,
    output wire y
);

    assign y = (sel == 4'b0000) ? d[0] :
               (sel == 4'b0001) ? d[1] :
               (sel == 4'b0010) ? d[2] :
               (sel == 4'b0011) ? d[3] :
               (sel == 4'b0100) ? d[4] :
               (sel == 4'b0101) ? d[5] :
               (sel == 4'b0110) ? d[6] :
               (sel == 4'b0111) ? d[7] :
               (sel == 4'b1000) ? d[8] :
               (sel == 4'b1001) ? d[9] :
               (sel == 4'b1010) ? d[10] :
               (sel == 4'b1011) ? d[11] :
               (sel == 4'b1100) ? d[12] :
               (sel == 4'b1101) ? d[13] :
               (sel == 4'b1110) ? d[14] :
               d[15];

endmodule