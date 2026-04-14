module adc_24_to_10 (
    input wire clk,
    input wire [23:0] analog_input,
    output reg [9:0] digital_output
);
    always @(posedge clk) begin
        digital_output <= analog_input[23:14]; // Keep the 10 most significant bits
    end
endmodule