module LDO_Control (
    input wire [7:0] reference_voltage, // 8-bit reference voltage input
    output wire enable_output // Output to enable/disable
);
    parameter THRESHOLD = 8'd100; // 100 as the threshold voltage
    
    assign enable_output = (reference_voltage > THRESHOLD) ? 1'b1 : 1'b0;

endmodule