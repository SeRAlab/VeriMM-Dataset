module DWT_Haar (
    input clk,
    input rst,
    input [15:0] data_in,  // 4 samples (4-bit each)
    output reg [15:0] data_out  // 4 transformed samples (4-bit each)
);
    reg [3:0] a0, a1, d0, d1; // Intermediate variables for averages and differences

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0;
        end else begin
            // Compute averages and differences
            a0 <= (data_in[3:0] + data_in[7:4]) >> 1; // Average of first two
            a1 <= (data_in[11:8] + data_in[15:12]) >> 1; // Average of last two
            d0 <= data_in[3:0] - data_in[7:4]; // Difference of first two
            d1 <= data_in[11:8] - data_in[15:12]; // Difference of last two
            
            // Output the transformed data
            data_out <= {a1, a0, d1, d0}; // Concatenate results
        end
    end
endmodule