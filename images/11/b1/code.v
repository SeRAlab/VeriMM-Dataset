module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [2:0] channel_select,  
    output reg ready  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000,  
              TRANSFER = 4'b0001,  
              COMPLETE = 4'b0010;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        ready <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    // Simulate data transfer process  
                    state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule