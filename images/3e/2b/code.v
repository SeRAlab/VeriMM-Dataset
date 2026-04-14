module LZW_Compressor(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid,
    output reg [15:0] compressed_out,
    output reg valid_out
);
    reg [15:0] dictionary [0:255]; // Simple dictionary for symbols
    reg [7:0] current_symbol;
    integer dict_size;
    
    initial begin
        dict_size = 256; // Initialize dictionary size
        valid_out = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset dictionary and output
            dict_size = 256;
            valid_out = 0;
            compressed_out = 0;
        end else if (valid) begin
            current_symbol = data_in;
            // Simplified compression logic (for example purposes)
            if (current_symbol < dict_size) begin
                compressed_out = dictionary[current_symbol];
                valid_out = 1;
            end else begin
                // If symbol not in dictionary, add it (simplified handling)
                dictionary[dict_size] = current_symbol; 
                dict_size = dict_size + 1;
                compressed_out = current_symbol; // Output the symbol itself
                valid_out = 1;
            end
        end
    end
endmodule