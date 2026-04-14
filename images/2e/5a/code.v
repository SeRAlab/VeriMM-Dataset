module adc_8_to_4 (
    input [7:0] voltage_in,
    output reg [3:0] voltage_out
);
    
    always @(*) begin
        voltage_out = voltage_in[7:4]; // Taking the top 4 bits
    end
    
endmodule