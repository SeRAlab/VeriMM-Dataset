module LIFO_stack (  
    input clk,  
    input reset,  
    input push,  
    input pop,  
    input [3:0] data_in,  
    output reg [3:0] top_data,  
    output reg empty,  
    output reg full  
);  
    reg [3:0] stack [0:7];  
    reg [2:0] sp; // stack pointer  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp <= 3'b000;  
            empty <= 1;  
            full <= 0;  
            top_data <= 4'b0000;  
        end else begin  
            if (push && !full) begin  
                stack[sp] <= data_in;  
                sp <= sp + 1;  
                empty <= 0;  
                if (sp == 7) full <= 1;  
            end  
            if (pop && !empty) begin  
                sp <= sp - 1;  
                if (sp > 0)  
                    top_data <= stack[sp - 1];  
                else  
                    top_data <= 4'b0000;  
                if (sp == 0) empty <= 1;  
                full <= 0;  
            end  
            if (sp > 0)  
                top_data <= stack[sp - 1];  
            else  
                top_data <= 4'b0000;  
        end  
    end  
endmodule