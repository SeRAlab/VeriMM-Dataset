module dma_controller (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] src_address,  
    input [7:0] dest_address,  
    output reg done  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, TRANSFER = 3'b001, COMPLETE = 3'b010;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        done <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    // Simulate data transfer process here  
                    state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule