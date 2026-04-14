module fifo_queue (  
    input clk,  
    input rst,  
    input enq,  
    input deq,  
    input [4:0] data_in,  
    output reg [4:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [4:0] fifo [3:0];  
    reg [1:0] head;  
    reg [1:0] tail;  
    reg [2:0] count;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (enq && !full) begin  
                fifo[tail] <= data_in;  
                tail <= (tail + 1) % 4;  
                count <= count + 1;  
            end  
            if (deq && !empty) begin  
                data_out <= fifo[head];  
                head <= (head + 1) % 4;  
                count <= count - 1;  
            end  
            full <= (count == 4);  
            empty <= (count == 0);  
        end  
    end  
endmodule