module DAC_24bit (
    input [23:0] binary_input,
    output reg [23:0] analog_output
);
    
    always @* begin
        analog_output = binary_input; // Output the same value as input
    end

endmodule