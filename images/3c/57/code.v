module stack #(parameter SIZE = 8, parameter WIDTH = 8) (  
    input wire clk,  
    input wire rst,  
    input wire push,  
    input wire pop,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] memory [0:SIZE-1];  
    reg [3:0] pointer;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pointer <= 0;  
            full <= 0;  
            empty <= 1;  
            data_out <= 0;  
        end else begin  
            if (push && !full) begin  
                memory[pointer] <= data_in;  
                pointer <= pointer + 1;  
                full <= (pointer + 1 == SIZE);  
                empty <= 0;  
            end  
            if (pop && !empty) begin  
                pointer <= pointer - 1;  
                data_out <= memory[pointer];  
                empty <= (pointer - 1 < 0);  
                full <= 0;  
            end  
            if (!pop && !push && !empty) begin  
                data_out <= memory[pointer - 1];  
            end  
        end  
    end  
endmodule