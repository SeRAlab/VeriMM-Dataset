module adc_controller (
    input wire clk,
    input wire reset,
    input wire [23:0] analog_value,
    output reg adc_output
);
    parameter THRESHOLD = 24'h800000; // 2^23

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            adc_output <= 1'b0;
        end else begin
            if (analog_value > THRESHOLD) begin
                adc_output <= 1'b1;
            end else begin
                adc_output <= 1'b0;
            end
        end
    end
endmodule