module LDO (
    input wire [7:0] Vref, // Reference Voltage
    input wire control,     // Control signal
    output reg [7:0] Vout   // Output Voltage
);
    always @(*) begin
        if (control) 
            Vout = Vref;     // Active mode
        else 
            Vout = 8'b00000000; // Standby mode
    end
endmodule