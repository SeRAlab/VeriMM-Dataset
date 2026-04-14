module mux8to1 (
    input [7:0] d,  // 8 data inputs
    input [2:0] s,  // 3 select lines
    output y        // output
);
    assign y = (s == 3'b000) ? d[0] :
               (s == 3'b001) ? d[1] :
               (s == 3'b010) ? d[2] :
               (s == 3'b011) ? d[3] :
               (s == 3'b100) ? d[4] :
               (s == 3'b101) ? d[5] :
               (s == 3'b110) ? d[6] :
               d[7];  // default case
endmodule