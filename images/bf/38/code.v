module top_module(
    input clk,
    input rst,
    input [31:0] data_in,
    input [31:0] key,
    output [31:0] data_out
);reg [7:0] segment_in [3:0];
reg [7:0] segment_key [3:0];
reg [7:0] segment_out [3:0];

reg [31:0] temp_data;

// Split input data into four 8-bit segments
assign segment_in[3] = data_in[31:24];
assign segment_in[2] = data_in[23:16];
assign segment_in[1] = data_in[15:8];
assign segment_in[0] = data_in[7:0];

// Split key into four 8-bit segments
assign segment_key[3] = key[31:24];
assign segment_key[2] = key[23:16];
assign segment_key[1] = key[15:8];
assign segment_key[0] = key[7:0];

// XOR each input segment with corresponding key segment
always @ (posedge clk) begin
    if (rst) begin
        segment_out[3] <= 0;
        segment_out[2] <= 0;
        segment_out[1] <= 0;
        segment_out[0] <= 0;
        temp_data <= 0;
    end else begin
        segment_out[3] <= segment_in[3] ^ segment_key[3];
        segment_out[2] <= segment_in[2] ^ segment_key[2];
        segment_out[1] <= segment_in[1] ^ segment_key[1];
        segment_out[0] <= segment_in[0] ^ segment_key[0];
        temp_data <= {segment_out[3], segment_out[2], segment_out[1], segment_out[0]};
    end
end

// Concatenate encrypted segments to form output
assign data_out = temp_data;

endmodule