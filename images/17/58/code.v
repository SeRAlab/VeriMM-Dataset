module DAC (
    input [15:0] binary_input,
    input mode_select,  // 0 for normal mode, 1 for inverted mode
    output reg [7:0] analog_output
);
    
    always @(*) begin
        if (mode_select == 0) begin
            // Normal mode
            analog_output = binary_input[15:8]; // Taking upper 8 bits
        end else begin
            // Inverted mode
            analog_output = 255 - binary_input[15:8]; // Inverting the output
        end
    end
endmodule