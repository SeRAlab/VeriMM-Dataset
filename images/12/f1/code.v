module DWT_Haar (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] approx_out,
    output reg [3:0] detail_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            approx_out <= 0;
            detail_out <= 0;
        end else begin
            // Haar transform logic
            approx_out <= (data_in[0] + data_in[1] + data_in[2] + data_in[3]) >> 2; // Average
            detail_out <= {data_in[0] - approx_out, data_in[1] - approx_out, data_in[2] - approx_out, data_in[3] - approx_out}; // Details
        end
    end
endmodule