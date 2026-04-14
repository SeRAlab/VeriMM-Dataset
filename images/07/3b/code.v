module d_flip_flop (  
    input wire clk,  
    input wire rst,  
    input wire d,  
    output reg q,  
    output reg q_bar  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            q <= 0;  
        end else begin  
            q <= d;  
        end  
    end  
    always @(q) begin  
        q_bar <= ~q;  
    end  
endmodule