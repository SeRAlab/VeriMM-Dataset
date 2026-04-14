module memory_manager #(parameter BLOCK_SIZE = 8, parameter NUM_BLOCKS = 4) (  
    input wire clk,  
    input wire rst,  
    input wire allocate,  
    input wire free,  
    output reg [BLOCK_SIZE-1:0] data_out,  
    output reg err  
);  

    reg [BLOCK_SIZE-1:0] memory [0:NUM_BLOCKS-1];  
    reg [2:0] head, tail;  
    reg [2:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            err <= 0;  
        end else begin  
            err <= 0;  
            if (allocate) begin  
                if (count < NUM_BLOCKS) begin  
                    data_out <= memory[head];  
                    head <= (head + 1) % NUM_BLOCKS;  
                    count <= count + 1;  
                end else begin  
                    err <= 1; // Memory full  
                end  
            end  
            if (free) begin  
                if (count > 0) begin  
                    tail <= (tail + 1) % NUM_BLOCKS;  
                    count <= count - 1;  
                end else begin  
                    err <= 1; // Invalid free  
                end  
            end  
        end  
    end  
endmodule