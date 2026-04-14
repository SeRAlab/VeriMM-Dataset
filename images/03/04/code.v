module fifo_queue #(parameter WIDTH = 8, DEPTH = 4) (  
    input clk,  
    input rst,  
    input enqueue,  
    input dequeue,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [2:0] head, tail, count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (enqueue && !full) begin  
                fifo[tail] <= data_in;  
                tail <= (tail + 1) % DEPTH;  
                count <= count + 1;  
            end  
            if (dequeue && !empty) begin  
                data_out <= fifo[head];  
                head <= (head + 1) % DEPTH;  
                count <= count - 1;  
            end  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule