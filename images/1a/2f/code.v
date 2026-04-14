module dwt_haar (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] approx_out,
    output reg [7:0] detail_out,
    output reg valid_out
);
    reg [7:0] data_buffer [0:7];
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            valid_out <= 0;
            approx_out <= 0;
            detail_out <= 0;
        end else if (valid_in) begin
            data_buffer[count] <= data_in;
            count <= count + 1;
            if (count == 7) begin
                approx_out <= (data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3]) >> 2;
                detail_out <= (data_buffer[0] - data_buffer[1] + data_buffer[2] - data_buffer[3]) >> 2;
                valid_out <= 1;
                count <= 0; // Reset counter for next input
            end
        end
    end
endmodule