module nvme_command_queue_manager (  
    input clk,  
    input rst_n,  
    input [31:0] cmd_in,  
    input cmd_valid,  
    input cmd_complete,  
    output reg [31:0] cmd_out,  
    output reg cmd_ready  
);  
    reg [31:0] queue [0:7];  
    reg [2:0] head, tail;  
    reg [2:0] count;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            head <= 0;  
            tail <= 0;  
            count <= 0;  
            cmd_ready <= 0;  
        end else begin  
            if (cmd_valid && count < 8) begin  
                queue[tail] <= cmd_in;  
                tail <= (tail + 1) % 8;  
                count <= count + 1;  
            end  

            if (cmd_complete && count > 0) begin  
                cmd_out <= queue[head];  
                head <= (head + 1) % 8;  
                count <= count - 1;  
                cmd_ready <= 1;  
            end else begin  
                cmd_ready <= 0;  
            end  
        end  
    end  
endmodule