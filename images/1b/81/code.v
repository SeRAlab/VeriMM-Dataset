module ADC_16bit (
    input wire clk,
    input wire enable,
    input wire [15:0] analog_input,
    output reg [3:0] digital_output
);
    
    always @(posedge clk) begin
        if (enable) begin
            digital_output <= analog_input[15:12]; // Take 4 MSBs
        end
    end
endmodule