module adc_controller (
    input wire [15:0] adc_input,
    input wire clk,
    input wire reset,
    input wire [15:0] threshold,
    output reg adc_output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            adc_output <= 1'b0;
        end else begin
            if (adc_input > threshold) begin
                adc_output <= 1'b1;
            end else begin
                adc_output <= 1'b0;
            end
        end
    end
endmodule