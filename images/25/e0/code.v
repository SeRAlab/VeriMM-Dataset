module dma_controller(  
    input clk,  
    input req1,  
    input req2,  
    output reg ack1,  
    output reg ack2,  
    output reg transferring  
);  
    reg state;  
    parameter IDLE = 1'b0, TRANSFER = 1'b1;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                transferring <= 0;  
                if (req1) begin  
                    ack1 <= 0;  
                    state <= TRANSFER;  
                end else if (req2) begin  
                    ack2 <= 0;  
                    state <= TRANSFER;  
                end  
            end  
            TRANSFER: begin  
                transferring <= 1;  
                if (ack1) begin  
                    ack1 <= 1;  
                    state <= IDLE;  
                end else if (ack2) begin  
                    ack2 <= 1;  
                    state <= IDLE;  
                end  
            end  
        endcase  
    end  
endmodule