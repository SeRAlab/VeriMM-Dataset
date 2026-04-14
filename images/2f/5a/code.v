module dma_controller (  
    input clk,  
    input reset,  
    input req1,  
    input req2,  
    output reg ack1,  
    output reg ack2,  
    output reg [7:0] data  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, TRANSFERRING1 = 2'b01, TRANSFERRING2 = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ack1 <= 0;  
            ack2 <= 0;  
            data <= 8'd0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack1 <= 0;  
                    ack2 <= 0;  
                    if (req1) begin  
                        state <= TRANSFERRING1;  
                    end else if (req2) begin  
                        state <= TRANSFERRING2;  
                    end  
                end  
                TRANSFERRING1: begin  
                    ack1 <= 1;  
                    data <= 8'hAA; // Example data for channel 1  
                    if (!req1) begin  
                        state <= IDLE;  
                    end  
                end  
                TRANSFERRING2: begin  
                    ack2 <= 1;  
                    data <= 8'hBB; // Example data for channel 2  
                    if (!req2) begin  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule