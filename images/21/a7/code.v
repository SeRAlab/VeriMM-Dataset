module ADC_Controller (
    input clk,
    input reset,
    input [23:0] adc_data,
    output reg [23:0] stored_data
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stored_data <= 24'b0;
    end else begin
        stored_data <= adc_data;
    end
end

endmodule