module DAC_8bit (
    input [7:0] binary_input,
    input reset,
    output reg [7:0] analog_output
);
    
    always @(*) begin
        if (reset) begin
            analog_output = 8'b00000000; // Output 0V
        end else begin
            analog_output = binary_input; // Output proportional to binary input
        end
    end

endmodule