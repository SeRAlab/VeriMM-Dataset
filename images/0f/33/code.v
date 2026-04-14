module gated_flip_flop(  
    input clk,  
    input rst,  
    input clk_en,  
    input d,  
    output reg q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            q <= 1'b0;  
        else if (clk_en)  
            q <= d;  
    end  
endmodule