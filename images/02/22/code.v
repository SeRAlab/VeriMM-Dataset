module DWT_Haar (
    input clk,
    input rst,
    input [15:0] signal_in,
    output reg [15:0] approx_out,
    output reg [15:0] detail_out
);
    reg [15:0] temp;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            approx_out <= 16'b0;
            detail_out <= 16'b0;
            temp <= 16'b0;
        end else begin
            // First clock cycle: Calculate temp values
            temp <= signal_in;
            approx_out <= (temp[15:8] + temp[7:0]) >> 1;  // Average
            detail_out <= (temp[15:8] - temp[7:0]) >> 1;  // Difference
        end
    end
endmodule