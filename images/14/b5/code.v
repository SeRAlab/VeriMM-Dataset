module rle_encoder (  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg [7:0] char_out,  
    output reg [7:0] count_out,  
    output reg valid_out  
);  
    reg [7:0] count;  
    reg current_char;  
    reg [7:0] max_length;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            valid_out <= 0;  
            current_char <= 0;  
            char_out <= 0;  
            count_out <= 0;  
        end else begin  
            if (data_in != current_char) begin  
                if (count > 0) begin  
                    char_out <= current_char;  
                    count_out <= count;  
                    valid_out <= 1;  
                    count <= 1;  
                end else begin  
                    count <= count + 1;  
                end  
                current_char <= data_in;  
            end else begin  
                if (count < max_length) begin  
                    count <= count + 1;  
                end  
            end  
        end  
    end  
endmodule