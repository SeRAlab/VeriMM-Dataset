module dwt_2d (
    input [15:0] pixel_in,
    output reg [7:0] approx_out,
    output reg [7:0] detail_out
);
    always @(*) begin
        // For simplicity, we will assume a basic DWT calculation
        approx_out = (pixel_in[15:12] + pixel_in[11:8] + pixel_in[7:4] + pixel_in[3:0]) >> 2; // Average for approx
        detail_out = (pixel_in[15:12] - pixel_in[11:8] + pixel_in[7:4] - pixel_in[3:0]) >> 2; // Difference for detail
    end
endmodule