module pll_8x (  
    input wire clk_ref,  
    input wire reset,  
    output reg clk_out  
);  

    reg [2:0] count;  

    always @(posedge clk_ref or posedge reset) begin  
        if (reset) begin  
            clk_out <= 0;  
            count <= 0;  
        end else begin  
            count <= count + 1;  
            if (count == 7) begin  
                clk_out <= ~clk_out;  
                count <= 0;  
            end  
        end  
    end  
endmodule