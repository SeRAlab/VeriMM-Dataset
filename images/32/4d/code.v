module divide_by_2 (  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 0;  
        end else begin  
            data_out <= data_in ^ data_out;  
        end  
    end  
endmodule