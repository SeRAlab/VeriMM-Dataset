module adc_converter (
    input wire clk,
    input wire reset,
    input wire [7:0] in_data,
    output reg out_data
);
    parameter THRESHOLD = 8'd128;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_data <= 0;
        end else begin
            if (in_data >= THRESHOLD) begin
                out_data <= 1;
            end else begin
                out_data <= 0;
            end
        end
    end
endmodule