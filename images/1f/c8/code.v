module divide_by_8(input clk, input [2:0] data_in, output reg divisible_by_8);  
    always @(posedge clk) begin  
        if (data_in == 3'b000)  
            divisible_by_8 <= 1;  
        else  
            divisible_by_8 <= 0;  
    end  
endmodule