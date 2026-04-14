module nvme_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter PROCESSING = 2'b01;  
    parameter COMPLETED = 2'b10;  
    parameter PROCESS_CYCLES = 5;  

    reg [3:0] cycle_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            cycle_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= PROCESSING;  
                        cycle_count <= 0;  
                    end  
                end  
                PROCESSING: begin  
                    if (cycle_count < PROCESS_CYCLES) begin  
                        cycle_count <= cycle_count + 1;  
                    end else begin  
                        state <= COMPLETED;  
                    end  
                end  
                COMPLETED: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule