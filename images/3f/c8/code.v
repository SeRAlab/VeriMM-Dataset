module LIFO_Stack #(parameter DEPTH = 4, parameter WIDTH = 8) (  
    input clk,  
    input reset,  
    input [WIDTH-1:0] data_in,  
    input push,  
    input pop,  
    output reg [WIDTH-1:0] top,  
    output reg empty  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] sp; // stack pointer  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp <= 0;  
            empty <= 1;  
            top <= 0;  
        end else begin  
            if (push && (sp < DEPTH)) begin  
                stack[sp] <= data_in;  
                sp <= sp + 1;  
                empty <= (sp + 1 == 0);  
            end  
            if (pop && (sp > 0)) begin  
                sp <= sp - 1;  
                top <= stack[sp-1];  
                empty <= (sp - 1 == 0);  
            end  
        end  
    end  
endmodule