module adc_8bit (
    input [2:0] voltage_input,  // 3-bit input
    output reg [7:0] digital_output // 8-bit output
);
    always @(*) begin
        digital_output = voltage_input * 32; // Scale the input
    end
endmodule