module adc_controller (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire [23:0] adc_input,
    output reg [23:0] adc_output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        adc_output <= 24'b0; // Reset output to zero
    end else if (valid) begin
        adc_output <= adc_input; // Latch the value when valid
    end
end

endmodule