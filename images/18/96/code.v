module nvme_controller(  
    input clk,  
    input reset,  
    input command,  
    output reg done  
);  
    reg [1:0] state;  
    reg [3:0] count;  
    parameter IDLE = 2'b00, PROCESSING = 2'b01, DONE = 2'b10;  
    parameter N = 4'b0011;  // Processing duration (3 clock cycles)  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            done <= 0;  
            count <= 0;  
        end else begin  
            case(state)  
                IDLE: begin  
                    done <= 0;  
                    if (command)  
                        state <= PROCESSING;  
                end  
                PROCESSING: begin  
                    count <= count + 1;  
                    if (count == N) begin  
                        state <= DONE;  
                        count <= 0;  
                    end  
                end  
                DONE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule