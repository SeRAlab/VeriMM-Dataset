module DWT_Haar (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [1:0] avg, diff;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else begin
            avg <= (data_in[3:2] + data_in[1:0]) >> 1; // Average
            diff <= (data_in[3:2] - data_in[1:0]);    // Difference
            data_out <= {avg, diff};                   // Combine results
        end
    end
endmodule