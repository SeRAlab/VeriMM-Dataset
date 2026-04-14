module lifo_stack(  
    input wire clk,  
    input wire rst,  
    input wire push,  
    input wire pop,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] stack [0:15];  
    reg [3:0] top;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            full <= 0;  
            empty <= 1;  
            data_out <= 0;  
        end else begin  
            if (push && !full) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= stack[top];  
            end  
            full <= (top == 16);  
            empty <= (top == 0);  
        end  
    end  
endmodule