module divide_by_2(input clk, input reset, input in, output reg out);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 1'b0;  
        end else begin  
            out <= in;  
        end  
    end  
endmodule