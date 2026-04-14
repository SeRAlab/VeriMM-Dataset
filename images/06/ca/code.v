module dac_controller (
    input [15:0] binary_input,
    output reg [7:0] analog_output
);
    
    always @(*) begin
        // Scale the 16-bit input to 8-bit output
        analog_output = binary_input[15:8]; // Taking the upper 8 bits as output
    end

endmodule