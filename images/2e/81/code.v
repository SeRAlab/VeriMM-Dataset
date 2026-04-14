module adc_controller (
    input clk,
    input rst_n,
    input [23:0] adc_value,
    output reg status
);
    parameter THRESHOLD = 24'hFFFFF0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            status <= 1'b0;
        end else begin
            if (adc_value > THRESHOLD) begin
                status <= 1'b1;
            end else begin
                status <= 1'b0;
            end
        end
    end
endmodule