module stack #(parameter SIZE = 4) (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] memory [0:SIZE-1];  
    reg [1:0] top;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (push && !full) begin  
                memory[top] <= data_in;  
                top <= top + 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= memory[top];  
            end  
            full <= (top == SIZE);  
            empty <= (top == 0);  
        end  
    end  
endmodule