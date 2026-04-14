module LDO (  
    input [4:0] Vin,  
    output reg Vout  
);  
    always @(*) begin  
        if (Vin >= 5)  
            Vout = 3;  
        else if (Vin < 4)  
            Vout = 0;  
        else  
            Vout = 3;  
    end  
endmodule