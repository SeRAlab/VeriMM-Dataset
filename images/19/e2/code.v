module stack #(parameter SIZE = 8, parameter DATA_WIDTH = 8) (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [DATA_WIDTH-1:0] data_in,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [DATA_WIDTH-1:0] stack_mem [0:SIZE-1];  
    reg [3:0] sp; // stack pointer  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sp <= 0;  
            full <= 0;  
            empty <= 1;  
            data_out <= 0;  
        end else begin  
            if (push && !full) begin  
                stack_mem[sp] <= data_in;  
                sp <= sp + 1;  
                empty <= 0;  
                if (sp + 1 == SIZE)  
                    full <= 1;  
            end  
            if (pop && !empty) begin  
                sp <= sp - 1;  
                data_out <= stack_mem[sp - 1];  
                full <= 0;  
                if (sp - 1 == 0)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule