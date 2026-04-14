module adc_controller (
    input wire clk,
    input wire [15:0] adc_input,
    output reg [11:0] dac_output,
    output reg valid_output
);
    always @(posedge clk) begin
        dac_output <= adc_input[15:4]; // Take upper 12 bits
        valid_output <= 1'b1; // Indicate valid output
    end
endmodule