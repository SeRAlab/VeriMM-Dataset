module sample_rate_converter (
    input clk,
    input rst,
    input [7:0] in_sample,
    output reg [7:0] out_sample
);
    reg [7:0] samples [0:1];
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            out_sample <= 0;
        end else begin
            samples[count] <= in_sample;
            count <= count + 1;
            if (count == 2) begin
                out_sample <= samples[0]; // Output the first sample
                count <= 0; // Reset count
            end
        end
    end
endmodule