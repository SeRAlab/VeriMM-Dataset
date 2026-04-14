module voltage_regulator (
    input [4:0] input_voltage,
    output reg [2:0] output_voltage
);

always @(*) begin
    if (input_voltage <= 5'b00010) 
        output_voltage = 3'b000; // Output 0V
    else if (input_voltage > 5'b00010 && (input_voltage - 5'b00010) >= 0) 
        output_voltage = input_voltage - 5'b00010; // Output input_voltage - 2
    else
        output_voltage = 3'b000; // Ensure output is not negative
end

endmodule