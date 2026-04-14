module adc_decoder (
    input [23:0] adc_input,
    output reg [3:0] voltage_output
);
    always @(*) begin
        if (adc_input > 24'd15) 
            voltage_output = 4'b1111;  // Output 15V for inputs greater than 15
        else 
            voltage_output = adc_input[3:0];  // Take the lower 4 bits as output
    end
endmodule