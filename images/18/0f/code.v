module dwt (
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] approx_out
);

reg [7:0] low_pass [0:7];
reg [7:0] high_pass [0:7];

integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        approx_out <= 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            low_pass[i] <= 8'b0;
            high_pass[i] <= 8'b0;
        end
    end else begin
        // Perform Haar wavelet transform
        for (i = 0; i < 8; i = i + 1) begin
            low_pass[i] <= (data_in[2*i] + data_in[2*i+1]) >> 1; // Averaging
            high_pass[i] <= (data_in[2*i] - data_in[2*i+1]) >> 1; // Differencing
        end
        // Combine low-pass coefficients to form output
        approx_out <= {low_pass[0], low_pass[1], low_pass[2], low_pass[3]};
    end
end

endmodule