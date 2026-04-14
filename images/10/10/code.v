module LIFO_Stack #(parameter SIZE = 8) (  
    input wire clk,  
    input wire reset,  
    input wire push,  
    input wire pop,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [7:0] stack [0:SIZE-1];  
    reg [3:0] top;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            top <= 0;  
            empty <= 1;  
            full <= 0;  
            data_out <= 8'b0;  
        end else begin  
            if (push && !full) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= 0;  
                if (top + 1 == SIZE) full <= 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                if (top == 1) empty <= 1;  
                full <= 0;  
            end  
        end  
    end  
endmodule