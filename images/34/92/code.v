module voltage_regulator(  
    input [7:0] Vin, // Input voltage (8-bit)  
    input [7:0] Vref, // Reference voltage (8-bit)  
    output reg [7:0] Vout // Regulated output voltage (8-bit)  
);  
    always @(*) begin  
        if (Vin < Vref)  
            Vout = Vin; // If input voltage is less than reference, output is input  
        else  
            Vout = Vref; // Otherwise, output is the reference voltage  
    end  
endmodule