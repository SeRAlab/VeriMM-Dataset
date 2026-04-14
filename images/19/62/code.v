module LinearVoltageRegulator (  
    input [7:0] Vin,   
    input [7:0] Vref,  
    output reg [7:0] Vout  
);  
    always @(*) begin  
        if (Vin > Vref)  
            Vout = Vref;  
        else  
            Vout = Vin;  
    end  
endmodule