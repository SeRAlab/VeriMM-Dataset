module sample_rate_converter (
    input wire clk,
    input wire reset,
    input wire [7:0] input_signal,
    input wire [9:0] rate_change, // positive for upsampling, negative for downsampling
    output reg [7:0] output_signal,
    output reg valid
);
    
    reg [9:0] count;
    reg [9:0] sample_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            sample_counter <= 0;
            output_signal <= 0;
            valid <= 0;
        end else begin
            if (rate_change > 0) begin // Upsampling
                if (sample_counter < rate_change) begin
                    sample_counter <= sample_counter + 1;
                    valid <= 0;
                end else begin
                    output_signal <= input_signal;
                    valid <= 1;
                    sample_counter <= 0;
                end
            end else if (rate_change < 0) begin // Downsampling
                if (count < -rate_change) begin
                    count <= count + 1;
                    valid <= 0;
                end else begin
                    output_signal <= input_signal;
                    valid <= 1;
                    count <= 0;
                end
            end
        end
    end
endmodule