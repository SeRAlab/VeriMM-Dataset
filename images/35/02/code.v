module DWT_Haar(
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire [15:0] data_in,
    output reg valid_out,
    output reg [15:0] approx_out,
    output reg [15:0] detail_out
);

reg [15:0] data_buffer [0:1];
reg [1:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        valid_out <= 0;
    end else if (valid_in) begin
        data_buffer[count] <= data_in;
        count <= count + 1;
        
        if (count == 1) begin
            approx_out <= (data_buffer[0] + data_buffer[1]) >> 1;
            detail_out <= (data_buffer[0] - data_buffer[1]) >> 1;
            valid_out <= 1;
            count <= 0; // Reset count for the next pair
        end
    end
end

endmodule