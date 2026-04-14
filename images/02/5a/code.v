module LDO_Regulator(  
    input [7:0] Vin,  
    input [7:0] Vref,  
    output [7:0] Vout  
);  
    assign Vout = (Vin > Vref) ? Vref : Vin;  
endmodule