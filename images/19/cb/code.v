module nvme_command_queue (  
    input clk,  
    input reset,  
    input write,  
    input read,  
    input [3:0] command_in,  
    output reg [3:0] command_out  
);  
    reg [3:0] queue [0:7];  
    reg [2:0] head, tail;  
    reg full;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 3'b0;  
            tail <= 3'b0;  
            full <= 1'b0;  
            command_out <= 4'b0;  
        end else begin  
            if (write && !full) begin  
                queue[tail] <= command_in;  
                tail <= (tail + 1) % 8;  
                if (tail == head)  
                    full <= 1'b1;  
            end  
            if (read && (head != tail || full)) begin  
                command_out <= queue[head];  
                head <= (head + 1) % 8;  
                full <= 1'b0;  
            end  
        end  
    end  
endmodule