module divide_by_2(input clk, input data, output reg q);  
    always @(posedge clk) begin  
        q <= data;  
    end  
endmodule