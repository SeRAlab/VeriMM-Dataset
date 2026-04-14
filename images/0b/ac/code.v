module DAC_8bit (
    input [7:0] binary_input,
    output reg [7:0] voltage_output
);
    
    parameter VOLTAGE_REF = 255; // Maximum voltage reference
    parameter STEP_SIZE = VOLTAGE_REF / 255; // Voltage increment per LSB
    
    always @(*) begin
        voltage_output = binary_input * STEP_SIZE; // Calculate voltage output
    end
endmodule