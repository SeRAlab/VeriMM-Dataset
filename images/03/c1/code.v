module lzw_compressor (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input valid_in,  
    output reg [9:0] code_out,  
    output reg valid_out  
);  

    reg [9:0] dictionary [0:511];  
    reg [8:0] next_code;  
    reg [7:0] current_string [0:15];  
    reg [3:0] str_length;  
    integer i;  
    initial begin  
        next_code = 0;  
        valid_out = 0;  
        for (i = 0; i < 256; i = i + 1)  
            dictionary[i] = i;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_code <= 256;  
            str_length <= 0;  
            valid_out <= 0;  
        end else if (valid_in) begin  
            if (str_length < 15) begin  
                current_string[str_length] <= data_in;  
                str_length <= str_length + 1;  
            end  
            // Simulating the LZW compression (simplified version)  
            code_out <= dictionary[current_string[0]];  
            valid_out <= 1;  
        end else begin  
            valid_out <= 0;  
        end  
    end  
endmodule