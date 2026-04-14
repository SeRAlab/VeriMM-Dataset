module LIFOStack #(parameter DEPTH = 8, WIDTH = 8) (  
    input wire clk,  
    input wire reset,  
    input wire push,  
    input wire pop,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] sp; // stack pointer  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp <= 0;  
            full <= 0;  
            empty <= 1;  
            data_out <= 0;  
        end else begin  
            if (push && !full) begin  
                stack[sp] <= data_in;  
                sp <= sp + 1;  
            end  
            if (pop && !empty) begin  
                sp <= sp - 1;  
                data_out <= stack[sp-1];  
            end  
            if (sp == DEPTH) begin  
                full <= 1;  
            end else begin  
                full <= 0;  
            end  
            if (sp == 0) begin  
                empty <= 1;  
            end else begin  
                empty <= 0;  
            end  
        end  
    end  
endmodule