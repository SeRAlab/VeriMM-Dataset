module RLE_Encoder(clk, reset, data_in, valid_in, value_out, count_out, valid_out);  
    input clk;  
    input reset;  
    input data_in;  
    input valid_in;  
    output reg [1:0] value_out;  
    output reg [3:0] count_out;  
    output reg valid_out;  

    reg [1:0] current_value;  
    reg [3:0] count;  
    reg encoding;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_value <= 2'b00;  
            count <= 4'b0000;  
            valid_out <= 0;  
            encoding <= 0;  
        end else if (valid_in) begin  
            if (data_in != current_value) begin  
                if (encoding) begin  
                    value_out <= current_value;  
                    count_out <= count;  
                    valid_out <= 1;  
                    encoding <= 0;  
                end  
                current_value <= data_in;  
                count <= 1;  
            end else begin  
                count <= count + 1;  
            end  
            encoding <= 1;  
        end else begin  
            valid_out <= 0;  
        end  
    end  
endmodule