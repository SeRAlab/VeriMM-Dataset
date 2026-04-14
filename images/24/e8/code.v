module sample_rate_converter(
    input clk,
    input reset,
    input [7:0] input_signal,
    input [3:0] conversion_ratio,
    output reg [7:0] output_signal,
    output reg output_valid
);
    reg [15:0] sample_counter;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_counter <= 0;
            count <= 0;
            output_signal <= 0;
            output_valid <= 0;
        end else begin
            if (count < conversion_ratio) begin
                count <= count + 1;
                output_valid <= 0;
            end else begin
                output_signal <= input_signal;
                output_valid <= 1;
                count <= 0;
            end
            sample_counter <= sample_counter + 1;
        end
    end
endmodule