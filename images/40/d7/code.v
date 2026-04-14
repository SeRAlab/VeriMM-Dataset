module fifo_queue #(parameter SIZE = 4, WIDTH = 8) (  
    input wire clk,  
    input wire rst,  
    input wire enqueue,  
    input wire dequeue,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [WIDTH-1:0] fifo [0:SIZE-1];  
    reg [1:0] head;  
    reg [1:0] tail;  
    integer count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            empty <= 1;  
            full <= 0;  
        end else begin  
            if (enqueue && !full) begin  
                fifo[tail] <= data_in;  
                tail <= (tail + 1) % SIZE;  
                count <= count + 1;  
                empty <= 0;  
                if (count == SIZE - 1)  
                    full <= 1;  
            end  
            if (dequeue && !empty) begin  
                data_out <= fifo[head];  
                head <= (head + 1) % SIZE;  
                count <= count - 1;  
                full <= 0;  
                if (count == 1)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule