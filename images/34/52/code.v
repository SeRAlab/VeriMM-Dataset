module sample_rate_converter(
    input clk,
    input rst,
    input [3:0] in_sample,
    output reg [3:0] out_sample
);

reg [3:0] samples [0:3]; // Shift register to hold the last 4 samples
integer count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        samples[0] <= 4'b0;
        samples[1] <= 4'b0;
        samples[2] <= 4'b0;
        samples[3] <= 4'b0;
        out_sample <= 4'b0;
        count <= 0;
    end else begin
        // Shift samples
        samples[3] <= samples[2];
        samples[2] <= samples[1];
        samples[1] <= samples[0];
        samples[0] <= in_sample;

        // Calculate average every 4 clock cycles
        count <= count + 1;
        if (count == 3) begin // Average after 4 samples
            out_sample <= (samples[0] + samples[1] + samples[2] + samples[3]) >> 2;
            count <= 0; // Reset count
        end
    end
end

endmodule