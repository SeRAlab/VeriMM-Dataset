module divide_by_2(  
    input clk,  
    input reset,  
    input data_in,  
    output reg data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 1'b0;  
        else  
            data_out <= data_in;  
    end  
endmodule