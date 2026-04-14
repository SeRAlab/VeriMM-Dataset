module switching_regulator(  
    input wire Vin,  
    input wire Vref,  
    output wire Vout  
);  
    assign Vout = (Vin > Vref) ? 1 : 0;  
endmodule