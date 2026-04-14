module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start_ch1,  
    input wire start_ch2,  
    input wire enable_ch1,  
    input wire enable_ch2,  
    output reg done_ch1,  
    output reg done_ch2  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, TRANSFER1 = 2'b01, TRANSFER2 = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            done_ch1 <= 0;  
            done_ch2 <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_ch1 && enable_ch1) begin  
                        state <= TRANSFER1;  
                        done_ch1 <= 0;  
                    end else if (start_ch2 && enable_ch2) begin  
                        state <= TRANSFER2;  
                        done_ch2 <= 0;  
                    end  
                end  
                TRANSFER1: begin  
                    // Transfer logic for channel 1 (simulated with a simple delay)  
                    done_ch1 <= 1;  
                    state <= IDLE;  
                end  
                TRANSFER2: begin  
                    // Transfer logic for channel 2 (simulated with a simple delay)  
                    done_ch2 <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule