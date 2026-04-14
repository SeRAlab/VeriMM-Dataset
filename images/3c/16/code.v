module d_flip_flop (  
    input wire clk,  
    input wire rst,  
    input wire en,  
    input wire d,  
    output reg q  
);  
    always @(posedge clk) begin  
        if (rst)  
            q <= 0;  
        else if (en)  
            q <= d;  
    end  
endmodule