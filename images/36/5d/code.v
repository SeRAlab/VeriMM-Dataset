module sample_rate_converter (
    input clk,
    input rst,
    input [15:0] sample_in,
    output reg [15:0] sample_out1,
    output reg [15:0] sample_out2
);
    
    reg [15:0] previous_sample;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_sample <= 16'b0;
            sample_out1 <= 16'b0;
            sample_out2 <= 16'b0;
        end else begin
            sample_out1 <= sample_in; // Output the current sample
            sample_out2 <= (previous_sample + sample_in) >> 1; // Linear interpolation
            previous_sample <= sample_in; // Store the current sample for next interpolation
        end
    end
endmodule