module fifo_queue #(parameter DEPTH = 8, parameter WIDTH = 8) (  
    input wire clk,  
    input wire rst,  
    input wire enqueue,  
    input wire dequeue,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];  
    reg [3:0] head;  
    reg [3:0] tail;  
    reg [3:0] count;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (enqueue && !full) begin  
                fifo_mem[tail] <= data_in;  
                tail <= (tail + 1) % DEPTH;  
                count <= count + 1;  
            end  
            if (dequeue && !empty) begin  
                data_out <= fifo_mem[head];  
                head <= (head + 1) % DEPTH;  
                count <= count - 1;  
            end  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule