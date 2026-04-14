module dma_controller (  
    input clk,  
    input rst,  
    input start,  
    input [1:0] channel_select,  
    input read_write,  // 1 for write, 0 for read  
    output reg [1:0] transfer_complete,  
    output reg [1:0] current_state  
);  
    reg [1:0] next_state;  
    parameter IDLE = 2'b00, TRANSFER = 2'b01, COMPLETE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_state <= IDLE;  
            transfer_complete <= 2'b00;  
        end else begin  
            current_state <= next_state;  
        end  
    end  

    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                transfer_complete = 2'b00;  
                if (start)  
                    next_state = TRANSFER;  
                else  
                    next_state = IDLE;  
            end  
            TRANSFER: begin  
                if (channel_select == 2'b00) begin  
                    // Logic for channel 0 data transfer  
                    transfer_complete[0] = 1'b0;  
                end else if (channel_select == 2'b01) begin  
                    // Logic for channel 1 data transfer  
                    transfer_complete[1] = 1'b0;  
                end  
                next_state = COMPLETE;  
            end  
            COMPLETE: begin  
                transfer_complete = (channel_select == 2'b00) ? 2'b01 : 2'b10;  
                next_state = IDLE;  
            end  
            default: begin  
                next_state = IDLE;  
                transfer_complete = 2'b00;  
            end  
        endcase  
    end  
endmodule