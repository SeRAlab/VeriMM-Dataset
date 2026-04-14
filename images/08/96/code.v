module mux8to1 (
    input [7:0] I,       // 8-bit input data
    input [2:0] S,       // 3-bit select line
    output Y             // Output
);
    assign Y = (S == 3'b000) ? I[0] :
               (S == 3'b001) ? I[1] :
               (S == 3'b010) ? I[2] :
               (S == 3'b011) ? I[3] :
               (S == 3'b100) ? I[4] :
               (S == 3'b101) ? I[5] :
               (S == 3'b110) ? I[6] :
               I[7]; // Default case for S = 111
endmodule