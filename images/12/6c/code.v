module fifo_queue(clk, rst, push, pop, data_in, data_out, empty, full);  
    input clk, rst, push, pop;  
    input [3:0] data_in;  
    output reg [3:0] data_out;  
    output reg empty, full;  

    reg [3:0] queue [3:0];  
    reg [1:0] head, tail;  
    reg [2:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            empty <= 1;  
            full <= 0;  
        end else begin  
            if (push && !full) begin  
                queue[tail] <= data_in;  
                tail <= (tail + 1) % 4;  
                count <= count + 1;  
            end  
            if (pop && !empty) begin  
                data_out <= queue[head];  
                head <= (head + 1) % 4;  
                count <= count - 1;  
            end  
            empty <= (count == 0);  
            full <= (count == 4);  
        end  
    end  
endmodule