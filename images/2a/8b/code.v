module adc_8bit (
    input [2:0] analog_input,
    output reg [7:0] digital_output
);
    always @(*) begin
        digital_output = {5'b00000, analog_input}; // Extend 3-bit input to 8-bit output
    end
endmodule