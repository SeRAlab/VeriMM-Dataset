module sr_flip_flop(  
    input S,  
    input R,  
    input clk,  
    output reg Q  
);  
    always @(posedge clk or posedge R) begin  
        if (R)  
            Q <= 0;  
        else if (S)  
            Q <= 1;  
    end  
endmodule