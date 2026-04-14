module tcp_segmentation (
    input clk,
    input reset,
    input [31:0] data_in,
    input [31:0] seq_num_in,
    input valid_in,
    output reg [15:0] data_out,
    output reg [31:0] seq_num_out,
    output reg valid_out
);
    reg [4:0] count;
    reg [31:0] temp_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            data_out <= 0;
            seq_num_out <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            temp_data <= data_in;
            count <= 0;
            valid_out <= 1;
        end else if (count < 2) begin
            data_out <= temp_data[15:0]; // output lower 16 bits
            seq_num_out <= seq_num_in + count; // increment sequence number
            temp_data <= temp_data >> 16; // shift for the next segment
            count <= count + 1;
        end else begin
            valid_out <= 0; // no more valid output
        end
    end
endmodule