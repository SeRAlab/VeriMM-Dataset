module sample_rate_converter (
    input clk,
    input reset,
    input [7:0] in_sample,
    output reg [7:0] out_sample
);
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_sample <= 8'b0;
            count <= 2'b0;
        end else begin
            if (count == 2'b11) begin
                out_sample <= in_sample;
                count <= 2'b0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule