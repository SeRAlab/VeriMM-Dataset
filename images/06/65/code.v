module DAC_16bit (  
    input [15:0] Vin,  
    output reg [31:0] Vout  
);  
    always @(*) begin  
        Vout = (Vin * 5000) / 65535; // Multiply by 5000 to represent 5.0 V in millivolts  
    end  
endmodule