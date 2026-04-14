module lzw_compressor(clk, reset, input_char, start, output_code, valid);  
    input clk;  
    input reset;  
    input [7:0] input_char;  
    input start;  
    output reg [11:0] output_code;  
    output reg valid;  

    reg [255:0] dictionary [0:255];  
    reg [8:0] next_index;  
    reg [7:0] current_pattern;  
    reg [7:0] new_entry;  
    reg [11:0] code;  

    initial begin  
        next_index = 0;  
        valid = 0;  
        output_code = 12'b0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_index <= 0;  
            valid <= 0;  
            output_code <= 12'b0;  
        end else if (start) begin  
            current_pattern <= input_char;  
            if (dictionary[current_pattern] == 0) begin  
                dictionary[current_pattern] <= next_index;  
                code <= next_index;  
                next_index <= next_index + 1;  
                valid <= 1;  
            end else begin  
                code <= dictionary[current_pattern];  
                valid <= 1;  
            end  
            output_code <= code;  
        end else begin  
            valid <= 0;  
        end  
    end  
endmodule