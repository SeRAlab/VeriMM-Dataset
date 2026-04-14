module nvme_queue_controller(  
    input wire clk,  
    input wire reset,  
    input wire [2:0] q_id,  
    input wire enqueue,  
    input wire dequeue,  
    output reg [7:0] queue_status,  
    output reg [3:0] command_count  
);  

    reg [3:0] command_count_internal [0:7];  
    reg [7:0] active_queues;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            queue_status <= 8'b00000000;  
            command_count <= 4'b0000;  
            active_queues <= 8'b00000000;  
            command_count_internal[0] <= 4'b0000;  
            command_count_internal[1] <= 4'b0000;  
            command_count_internal[2] <= 4'b0000;  
            command_count_internal[3] <= 4'b0000;  
            command_count_internal[4] <= 4'b0000;  
            command_count_internal[5] <= 4'b0000;  
            command_count_internal[6] <= 4'b0000;  
            command_count_internal[7] <= 4'b0000;  
        end else begin  
            if (enqueue) begin  
                active_queues[q_id] <= 1;  
                command_count_internal[q_id] <= command_count_internal[q_id] + 1;  
            end  
            if (dequeue) begin  
                if (command_count_internal[q_id] > 0)  
                    command_count_internal[q_id] <= command_count_internal[q_id] - 1;  
                if (command_count_internal[q_id] == 0)  
                    active_queues[q_id] <= 0;  
            end  
            queue_status <= active_queues;  
            command_count <= command_count_internal[q_id];  
        end  
    end  
endmodule