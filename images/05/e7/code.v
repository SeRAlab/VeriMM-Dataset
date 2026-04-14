module fifo_queue(  
    input clk,  
    input reset,  
    input enqueue,  
    input dequeue,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] fifo [0:3];  
    reg [1:0] head, tail, count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (enqueue && !full) begin  
                fifo[tail] <= data_in;  
                tail <= (tail + 1) % 4;  
                count <= count + 1;  
                empty <= 0;  
                if (count == 3)  
                    full <= 1;  
            end  
            if (dequeue && !empty) begin  
                data_out <= fifo[head];  
                head <= (head + 1) % 4;  
                count <= count - 1;  
                full <= 0;  
                if (count == 1)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule