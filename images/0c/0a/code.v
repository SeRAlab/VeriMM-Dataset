module dma_controller (  
    input clk,  
    input reset,  
    input [1:0] channel_select,  
    input [3:0] channel_enable,  
    input start_transfer,  
    output reg transfer_complete  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  
    parameter IDLE = 2'b00, TRANSFER = 2'b01, COMPLETE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                transfer_complete = 0;  
                if (start_transfer && channel_enable[channel_select])  
                    next_state = TRANSFER;  
                else  
                    next_state = IDLE;  
            end  
            TRANSFER: begin  
                transfer_complete = 0;  
                next_state = COMPLETE;  
            end  
            COMPLETE: begin  
                transfer_complete = 1;  
                next_state = IDLE;  
            end  
            default: begin  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule