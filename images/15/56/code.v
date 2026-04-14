module LDO_Regulator (  
    input wire [7:0] Vref,       // Reference voltage  
    input wire [7:0] Vin,        // Input voltage  
    input wire [7:0] Iload,      // Load current  
    input wire [7:0] Vdropout,   // Dropout voltage  
    input wire enable,            // Enable signal  
    output reg [7:0] Vout        // Output voltage  
);  

always @(*) begin  
    if (enable) begin  
        if (Vin >= (Vref + Vdropout)) begin  
            Vout = Vref;  
        end else begin  
            Vout = Vin;  
        end  
    end else begin  
        Vout = 8'b0;  
    end  
end  
endmodule