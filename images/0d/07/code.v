module fifo_queue #(parameter DEPTH = 4, DATA_WIDTH = 8) (  
    input clk,  
    input reset,  
    input [DATA_WIDTH-1:0] data_in,  
    input write,  
    input read,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];  
    reg [3:0] head, tail, count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (write && !full) begin  
                fifo_mem[tail] <= data_in;  
                tail <= (tail + 1) % DEPTH;  
                count <= count + 1;  
            end  
            if (read && !empty) begin  
                data_out <= fifo_mem[head];  
                head <= (head + 1) % DEPTH;  
                count <= count - 1;  
            end  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule