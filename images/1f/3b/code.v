module RLE_Encoder (  
    input clk,  
    input rst,  
    input data_in,  
    output reg [1:0] count_out,  
    output reg data_out  
);  

    reg [1:0] count;  
    reg last_data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            count_out <= 0;  
            data_out <= 0;  
            last_data <= 0;  
        end else begin  
            if (data_in == last_data) begin  
                count <= count + 1;  
            end else begin  
                count_out <= count;  
                data_out <= last_data;  
                last_data <= data_in;  
                count <= 1;  
            end  
        end  
    end  

    always @(negedge clk) begin  
        if (count > 0) begin  
            count_out <= count;  
            data_out <= last_data;  
        end  
    end  
endmodule