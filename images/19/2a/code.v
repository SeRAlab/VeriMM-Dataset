module LDO_Controller(  
    input wire [7:0] Vin,    // Input voltage  
    input wire [7:0] Vref,   // Reference voltage  
    output reg En,           // Enable signal  
    output reg PWM           // PWM output signal  
);  
    always @(*) begin  
        // Enable signal logic  
        if (Vin > Vref)  
            En = 1;  
        else  
            En = 0;  
          
        // PWM signal generation based on voltage difference  
        PWM = Vin - Vref;  
    end  
endmodule