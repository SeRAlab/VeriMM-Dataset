module clock_divider #(parameter DIVIDE_BY = 4) (  
    input wire clk_in,  
    input wire reset,  
    output reg clk_out  
);  
    integer count;  
    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            clk_out <= 0;  
        end else begin  
            if (count == DIVIDE_BY - 1) begin  
                clk_out <= ~clk_out;  
                count <= 0;  
            end else begin  
                count <= count + 1;  
            end  
        end  
    end  
endmodule