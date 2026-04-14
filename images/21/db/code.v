module LDO_Regulator(  
    input wire [7:0] Vin,  // Input voltage (in mV)  
    output wire Vout_ctrl  // Control signal for output regulation  
);  
    // Threshold voltage is 2500 mV (2.5V)  
    assign Vout_ctrl = (Vin >= 8'd2500) ? 1'b1 : 1'b0;  
endmodule