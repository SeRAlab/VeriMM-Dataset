module lzw_compressor(
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [15:0] compressed_out,
    output reg valid_out
);
    // Internal registers and parameters
    reg [7:0] dictionary [0:255]; // Simple dictionary
    integer dict_count;
    integer i;
    reg [7:0] current_string;
    reg [7:0] next_char;
    
    initial begin
        dict_count = 0;
        valid_out = 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dict_count <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            current_string = data_in;
            // Simple logic for LZW: Add to dictionary and output compressed
            if(dict_count < 256) begin
                dictionary[dict_count] = current_string;
                compressed_out = dict_count; // output the index of the dictionary
                dict_count = dict_count + 1;
                valid_out <= 1;
            end else begin
                // For simplicity, just output the last index if full
                compressed_out = dict_count - 1;
                valid_out <= 1;
            end
        end else begin
            valid_out <= 0;
        end
    end
endmodule