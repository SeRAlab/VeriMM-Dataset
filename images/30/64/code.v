module adc_16bit (
    input wire clk,
    input wire [15:0] analog_input,
    output reg [3:0] digital_output
);
    always @(posedge clk) begin
        // Convert the 16-bit analog input to a 4-bit digital output.
        // For simplicity, we will scale down the 16-bit value to fit into 4 bits.
        digital_output <= analog_input[15:12]; // taking the top 4 bits for simplicity
    end
endmodule