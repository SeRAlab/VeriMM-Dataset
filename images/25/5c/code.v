module adc_controller (
    input wire clk,
    input wire enable,
    input wire [23:0] adc_input,
    output reg [23:0] adc_output
);

always @(posedge clk) begin
    if (enable) begin
        adc_output <= adc_input;
    end
end

endmodule