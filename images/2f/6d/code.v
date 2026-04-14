module LDO_Regulator(  
    input wire [7:0] Vin,    // 8-bit input voltage  
    input wire enable,       // Enable signal  
    output reg [7:0] Vout    // 8-bit output voltage  
);  
    always @(*) begin  
        if (enable)  
            Vout = Vin;  
        else  
            Vout = 8'b0;  
    end  
endmodule