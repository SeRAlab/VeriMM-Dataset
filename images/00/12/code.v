module fifo_queue #(parameter WIDTH = 8, parameter DEPTH = 16) (  
    input clk,  
    input reset,  
    input enqueue,  
    input dequeue,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [WIDTH-1:0] memory [0:DEPTH-1];  
    reg [3:0] head, tail;  
    reg [4:0] count;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            empty <= 1;  
            full <= 0;  
        end else begin  
            if (enqueue && !full) begin  
                memory[tail] <= data_in;  
                tail <= (tail + 1) % DEPTH;  
                count <= count + 1;  
                empty <= 0;  
                full <= (count + 1 == DEPTH);  
            end  
            if (dequeue && !empty) begin  
                data_out <= memory[head];  
                head <= (head + 1) % DEPTH;  
                count <= count - 1;  
                full <= 0;  
                empty <= (count - 1 == 0);  
            end  
        end  
    end  
endmodule