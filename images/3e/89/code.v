module switching_regulator_controller(  
    input wire [7:0] Vin,       // Input voltage  
    input wire [7:0] Vref,      // Reference voltage  
    output reg Vout_control      // Control signal for the regulator  
);  
    always @(*) begin  
        if (Vin > Vref)  
            Vout_control = 1'b1; // Turn on the regulator  
        else  
            Vout_control = 1'b0; // Turn off the regulator  
    end  
endmodule