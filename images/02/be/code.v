module nvme_controller(  
    input clk,  
    input reset,  
    input start,  
    input done,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter PROCESSING = 2'b01;  
    parameter COMPLETE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= PROCESSING;  
                end  
                PROCESSING: begin  
                    if (done)  
                        state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    if (!start)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule