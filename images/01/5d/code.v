module fifo_queue (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    input push,  
    input pop,  
    output reg [3:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [3:0] queue [3:0];  
    reg [1:0] head, tail, count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            head <= 2'b00;  
            tail <= 2'b00;  
            count <= 2'b00;  
            empty <= 1;  
            full <= 0;  
        end else begin  
            if (push && !full) begin  
                queue[tail] <= data_in;  
                tail <= tail + 1;  
                count <= count + 1;  
                empty <= 0;  
                if (count == 2'b11) full <= 1;  
            end  

            if (pop && !empty) begin  
                data_out <= queue[head];  
                head <= head + 1;  
                count <= count - 1;  
                full <= 0;  
                if (count == 2'b01) empty <= 1;  
            end  
        end  
    end  
endmodule