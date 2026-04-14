module voltage_regulator #(parameter GAIN = 2, MAX_VOUT = 5)  
(  
    input [7:0] Vin,  
    output reg [7:0] Vout  
);  
    always @(*) begin  
        Vout = Vin * GAIN;  
        if (Vout > MAX_VOUT)  
            Vout = MAX_VOUT;  
    end  
endmodule