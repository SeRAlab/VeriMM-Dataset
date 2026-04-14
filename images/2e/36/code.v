module sample_rate_converter (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [3:0] input_signal,
    output reg [3:0] output_signal
);
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            output_signal <= 0;
        end else if (valid) begin
            if (count == 1) begin
                output_signal <= input_signal;
            end
            count <= count + 1;
            if (count == 1) begin
                count <= 0;
            end
        end
    end
endmodule