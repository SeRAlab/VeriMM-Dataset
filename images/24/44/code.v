module mux4to1 (  
    input [3:0] I,  // 4 input lines  
    input [1:0] S,  // 2 selection lines  
    output Y        // output line  
);  
    assign Y = (S == 2'b00) ? I[0] :  
               (S == 2'b01) ? I[1] :  
               (S == 2'b10) ? I[2] :  
               (S == 2'b11) ? I[3] : 1'bx;  
endmodule