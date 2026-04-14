module dac_controller (
    input wire [23:0] digital_input,
    output reg [23:0] analog_output
);
    
    always @* begin
        // Direct mapping from digital input to analog output
        analog_output = digital_input;
    end
    
endmodule