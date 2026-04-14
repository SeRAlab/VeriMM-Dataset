module d_flip_flop (  
    input clk,  
    input rst,  
    input en,  
    input d,  
    output reg q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            q <= 0;  
        else if (en)  
            q <= d;  
    end  
endmodule