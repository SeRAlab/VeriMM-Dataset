module LIFO_Stack (  
    input clk,  
    input reset,  
    input push,  
    input pop,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] stack [4:0];  
    reg [2:0] top;  

    initial begin  
        top = 3'b000;  
        full = 0;  
        empty = 1;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            top <= 3'b000;  
            full <= 0;  
            empty <= 1;  
        end  
        else begin  
            if (push && !full) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= 0;  
                if (top + 1 == 5)  
                    full <= 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                full <= 0;  
                if (top - 1 < 0)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule