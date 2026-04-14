module LZW_Compressor(  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input valid_in,  
    output reg [15:0] code_out,  
    output reg valid_out  
);  

    reg [15:0] dictionary[0:255];  
    reg [7:0] current_string;  
    reg [7:0] next_char;  
    reg [7:0] dict_size;  
    reg [7:0] state;  

    initial begin  
        dict_size = 0;  
        state = 0;  
        valid_out = 0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dict_size <= 0;  
            state <= 0;  
            valid_out <= 0;  
        end else if (valid_in) begin  
            next_char <= data_in;  
            if (state == 0) begin  
                current_string <= next_char;  
                state <= 1;  
            end else begin  
                if (dictionary[current_string] != 0) begin  
                    current_string <= dictionary[current_string];  
                end else begin  
                    code_out <= current_string;  
                    valid_out <= 1;  
                    dictionary[dict_size] <= current_string;  
                    dict_size <= dict_size + 1;  
                    current_string <= next_char;  
                    state <= 1;  
                end  
            end  
        end else begin  
            valid_out <= 0;  
        end  
    end  
endmodule