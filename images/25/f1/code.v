module sample_rate_converter (
    input clk,
    input rst,
    input [7:0] in_sample,
    output reg [7:0] out_sample1,
    output reg [7:0] out_sample2
);
    reg [7:0] sample_store;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sample_store <= 8'b0;
            out_sample1 <= 8'b0;
            out_sample2 <= 8'b0;
        end else begin
            sample_store <= in_sample;
            out_sample1 <= sample_store;
            out_sample2 <= sample_store;
        end
    end
endmodule