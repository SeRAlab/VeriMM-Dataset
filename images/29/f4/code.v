module DAC_8bit (
    input [7:0] binary_input,
    output reg [7:0] voltage_output
);
    always @(*) begin
        voltage_output = binary_input; // Direct mapping for simplicity
    end
endmodule