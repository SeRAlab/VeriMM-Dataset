module sample_rate_converter (
    input clk,
    input rst_n,
    input [7:0] input_sample,
    output reg [7:0] output_sample,
    output reg valid
);
    reg [7:0] buffer [1:0]; // Buffer for two samples
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            valid <= 0;
            output_sample <= 0;
        end else begin
            buffer[count] <= input_sample;
            count <= count + 1;

            if (count == 2) begin
                output_sample <= (buffer[0] + buffer[1]) / 2;
                valid <= 1;
                count <= 0; // Reset count after two samples are processed
            end else begin
                valid <= 0; // Not valid until two samples are buffered
            end
        end
    end
endmodule