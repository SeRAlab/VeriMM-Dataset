module mux4to1 (  
    input wire A,  
    input wire B,  
    input wire C,  
    input wire D,  
    input wire S0,  
    input wire S1,  
    output wire Y  
);  
    assign Y = (S0 == 0 && S1 == 0) ? A :  
               (S0 == 0 && S1 == 1) ? B :  
               (S0 == 1 && S1 == 0) ? C :  
               (S0 == 1 && S1 == 1) ? D : 1'b0;  
endmodule