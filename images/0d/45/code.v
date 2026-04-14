module LDO_Regulator(  
    input wire [7:0] Vin,     // Input Voltage  
    input wire [7:0] Vref,    // Reference Voltage  
    input wire enable,         // Enable signal  
    output reg [7:0] Vout     // Output Voltage  
);  
    always @(*) begin  
        if (enable) begin  
            if (Vin >= Vref)  
                Vout = Vref;  
            else  
                Vout = Vin;  
        end else begin  
            Vout = 8'b00000000;  
        end  
    end  
endmodule