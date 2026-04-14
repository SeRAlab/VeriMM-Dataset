module LDO_Regulator (  
    input [7:0] Vin,  
    output reg [7:0] Vout  
);  
    always @(*) begin  
        if (Vin > 8'd50) // Vin > 0.5V (scaled to 8-bit)  
            Vout = Vin - 8'd5; // Vdrop = 0.5V (scaled to 8-bit)  
        else  
            Vout = Vin;  
    end  
endmodule