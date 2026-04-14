module rs_encoder (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] encoded_out,
    output reg encoded_valid
);
    reg [3:0] count; // Counts the number of data symbols processed
    reg [7:0] data_buffer[0:3]; // Buffer for 4 data symbols

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            encoded_valid <= 0;
            encoded_out <= 0;
        end else if (data_valid && count < 4) begin
            data_buffer[count] <= data_in;
            count <= count + 1;
        end else if (count == 4) begin
            // Simple parity calculation (for illustration, not true RS encoding)
            encoded_out <= data_buffer[0] ^ data_buffer[1] ^ data_buffer[2] ^ data_buffer[3];
            encoded_valid <= 1;
            count <= 0; // Reset for next input
        end else begin
            encoded_valid <= 0; // No new encoded output
        end
    end
endmodule