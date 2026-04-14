module nvme_controller(clk, reset, start, done, state);  
    input clk;  
    input reset;  
    input start;  
    input done;  
    output reg [1:0] state; // 00: IDLE, 01: PROCESSING, 10: DONE  

    // State encoding  
    parameter IDLE = 2'b00;  
    parameter PROCESSING = 2'b01;  
    parameter DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= PROCESSING;  
                    end  
                end  
                PROCESSING: begin  
                    if (done) begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule