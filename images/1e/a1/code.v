module LIFO_stack(  
    input clk,  
    input rst,  
    input [7:0] push_val,  
    input push_enable,  
    input pop_enable,  
    output reg [7:0] pop_val,  
    output reg empty  
);  

    reg [7:0] stack [0:7];  
    reg [2:0] sp; // stack pointer  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sp <= 0;  
            empty <= 1;  
            pop_val <= 0;  
        end else begin  
            if (push_enable && sp < 8) begin  
                stack[sp] <= push_val;  
                sp <= sp + 1;  
                empty <= (sp + 1 == 8) ? 0 : 1;  
            end  
            if (pop_enable && sp > 0) begin  
                sp <= sp - 1;  
                pop_val <= stack[sp];  
                empty <= (sp == 1) ? 1 : 0;  
            end  
        end  
    end  
endmodule