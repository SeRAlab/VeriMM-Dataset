module mux8to1 (  
    input wire [7:0] D,  
    input wire [2:0] S,  
    output wire Y  
);  
    assign Y = (S == 3'b000) ? D[0] :  
               (S == 3'b001) ? D[1] :  
               (S == 3'b010) ? D[2] :  
               (S == 3'b011) ? D[3] :  
               (S == 3'b100) ? D[4] :  
               (S == 3'b101) ? D[5] :  
               (S == 3'b110) ? D[6] :  
               (S == 3'b111) ? D[7] : 1'b0;  
endmodule