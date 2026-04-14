module linear_voltage_regulator (  
    input wire [7:0] Vref,  
    input wire [7:0] Vin,  
    output wire [7:0] Vout  
);  
    assign Vout = (Vin >= Vref) ? Vref : Vin;  
endmodule