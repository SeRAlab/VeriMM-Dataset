module divide_by_2(input wire clk,  
                   input wire rst,  
                   input wire data_in,  
                   output reg data_out);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 0;  
        else  
            data_out <= data_in;  
    end  
endmodule