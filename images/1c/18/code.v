module voltage_comparator (  
    input [4:0] Vin,  
    input [4:0] Vref,  
    output reg Vout  
);  
    always @(*) begin  
        if (Vin > Vref)  
            Vout = 1;  
        else  
            Vout = 0;  
    end  
endmodule