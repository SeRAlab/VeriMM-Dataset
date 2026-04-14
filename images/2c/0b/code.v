module fifo_queue(  
    input clk,  
    input rst,  
    input [7:0] enq,  
    output reg [7:0] deq,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] queue [3:0];  
    reg [1:0] head;  
    reg [1:0] tail;  
    reg [2:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 2'b00;  
            tail <= 2'b00;  
            count <= 3'b000;  
            deq <= 8'b0;  
            full <= 1'b0;  
            empty <= 1'b1;  
        end else begin  
            if (count < 4) begin  
                full <= 1'b0;  
                if (enq != 8'b0) begin  
                    queue[tail] <= enq;  
                    tail <= (tail + 1) % 4;  
                    count <= count + 1;  
                end  
            end else begin  
                full <= 1'b1;  
            end  

            if (count > 0) begin  
                empty <= 1'b0;  
                deq <= queue[head];  
                head <= (head + 1) % 4;  
                count <= count - 1;  
            end else begin  
                empty <= 1'b1;  
                deq <= 8'b0;  
            end  
        end  
    end  
endmodule