module mux4to1 (  
    input wire I0,  
    input wire I1,  
    input wire I2,  
    input wire I3,  
    input wire S0,  
    input wire S1,  
    output wire Y  
);  
    assign Y = (S1 == 0 && S0 == 0) ? I0 :  
               (S1 == 0 && S0 == 1) ? I1 :  
               (S1 == 1 && S0 == 0) ? I2 :  
               I3;  
endmodule