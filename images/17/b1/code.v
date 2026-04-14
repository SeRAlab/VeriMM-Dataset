module RLE_Encoder(  
    input clk,  
    input rst,  
    input [1:0] data_in,  
    input data_valid,  
    output reg [7:0] count_out,  
    output reg [1:0] value_out,  
    output reg valid_out  
);  

    reg [1:0] current_value;  
    reg [7:0] current_count;  
    reg encoding;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count_out <= 0;  
            value_out <= 0;  
            valid_out <= 0;  
            current_count <= 0;  
            current_value <= 0;  
            encoding <= 0;  
        end else if (data_valid) begin  
            if (!encoding) begin  
                current_value <= data_in;  
                current_count <= 1;  
                encoding <= 1;  
            end else if (data_in == current_value) begin  
                current_count <= current_count + 1;  
            end else begin  
                count_out <= current_count;  
                value_out <= current_value;  
                valid_out <= 1;  
                current_value <= data_in;  
                current_count <= 1;  
            end  
        end  
    end  

    always @(posedge clk) begin  
        if (valid_out) begin  
            encoding <= 0;  
            valid_out <= 0;  
        end  
    end  
endmodule