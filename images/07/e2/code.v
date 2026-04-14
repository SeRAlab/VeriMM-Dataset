module DWT_Haar(
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] approx_out,
    output reg [3:0] detail_out
);

reg [3:0] temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        approx_out <= 4'b0000;
        detail_out <= 4'b0000;
    end else begin
        // Haar Wavelet Transform
        approx_out <= (data_in[0] + data_in[1]) >> 1; // Compute approximation
        detail_out <= (data_in[0] - data_in[1]); // Compute detail
    end
end
endmodule