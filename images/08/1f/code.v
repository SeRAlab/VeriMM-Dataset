module adc_controller (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [23:0] adc_data,
    output reg [23:0] data_out,
    output reg data_ready
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 24'b0;
        data_ready <= 1'b0;
    end else begin
        if (valid) begin
            data_out <= adc_data;
            data_ready <= 1'b1;
        end else begin
            data_ready <= 1'b0;
        end
    end
end

endmodule