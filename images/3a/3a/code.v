module lzw_compression (  
    input clk,  
    input reset,  
    input [7:0] input_symbol,  
    output reg [11:0] output_code,  
    output reg valid_output  
);  
    reg [7:0] dictionary [0:255];  
    reg [11:0] code;  
    reg [8:0] dict_index;  
    integer i;  

    initial begin  
        for (i = 0; i < 256; i = i + 1) begin  
            dictionary[i] = i;  
        end  
        dict_index = 0;  
        code = 0;  
        valid_output = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            dict_index <= 0;  
            valid_output <= 0;  
        end else begin  
            output_code <= dictionary[input_symbol];  
            valid_output <= 1;  
            if (dict_index < 255) begin  
                dictionary[dict_index] <= input_symbol;  
                dict_index <= dict_index + 1;  
            end  
        end  
    end  
endmodule