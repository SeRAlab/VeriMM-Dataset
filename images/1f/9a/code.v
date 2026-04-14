module LZW_Encoder(clk, reset, input_char, start, output_code, valid);  
    input clk, reset, start;  
    input [3:0] input_char;  
    output reg [7:0] output_code;  
    output reg valid;  

    reg [3:0] dictionary [0:15];  
    reg [3:0] current_input;  
    reg [3:0] next_code;  
    integer dict_size;  

    initial begin  
        dict_size = 0;  
        next_code = 0;  
        valid = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            dict_size <= 0;  
            next_code <= 0;  
            valid <= 0;  
        end else if (start) begin  
            if (dict_size < 16) begin  
                dictionary[dict_size] <= input_char;  
                output_code <= {next_code, input_char};  
                dict_size <= dict_size + 1;  
                valid <= 1;  
                next_code <= next_code + 1;  
            end else begin  
                // Output the last valid code  
                output_code <= {next_code, input_char};  
                valid <= 1;  
            end  
        end else begin  
            valid <= 0;  
        end  
    end  
endmodule