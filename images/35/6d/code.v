module lzw_compressor(clk, reset, input_byte, valid_input, compressed_output, output_valid);  
    input clk;  
    input reset;  
    input [7:0] input_byte;  
    input valid_input;  
    output reg [15:0] compressed_output;  
    output reg output_valid;  

    reg [11:0] dict [0:4095]; // Dictionary for LZW, max size 4096  
    reg [11:0] current_code;  
    reg [11:0] next_code;  
    reg [7:0] current_byte;  
    reg [11:0] search_string;  
    integer i;  

    initial begin  
        next_code = 256; // Start after standard ASCII characters  
        for (i = 0; i < 256; i = i + 1) begin  
            dict[i] = i;  
        end  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_code <= 0;  
            output_valid <= 0;  
        end else if (valid_input) begin  
            search_string = {search_string[7:0], input_byte}; // Update search string  
            if (dict[search_string] != 0) begin  
                current_code = dict[search_string]; // Found in dictionary  
            end else begin  
                compressed_output <= current_code;  
                output_valid <= 1;  
                dict[search_string] <= next_code; // Add to dictionary  
                next_code = next_code + 1;  
                search_string = input_byte; // Reset search string  
            end  
        end  
    end  
endmodule