module LIFOStack #(parameter WIDTH = 8, DEPTH = 4) (  
    input wire clk,  
    input wire rst,  
    input wire push,  
    input wire pop,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] sp; // stack pointer  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sp <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (push && !full) begin  
                stack[sp] <= data_in;  
                sp <= sp + 1;  
            end  
            if (pop && !empty) begin  
                sp <= sp - 1;  
                data_out <= stack[sp];  
            end  
            full <= (sp == DEPTH);  
            empty <= (sp == 0);  
        end  
    end  
endmodule