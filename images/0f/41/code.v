module fir_filter (
    input clk,
    input rst,
    input [3:0] sample,
    output reg [7:0] result
);
    reg [3:0] samples [0:3]; // Array to hold the last 4 samples
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 8'b0;
            for (i = 0; i < 4; i = i + 1) begin
                samples[i] <= 4'b0;
            end
        end else begin
            // Shift the samples
            samples[3] <= samples[2];
            samples[2] <= samples[1];
            samples[1] <= samples[0];
            samples[0] <= sample;

            // Calculate the FIR output
            result <= (samples[0] * 1) + (samples[1] * 2) + (samples[2] * 3) + (samples[3] * 4);
        end
    end
endmodule