module dma_controller(  
    input clk,  
    input rst,  
    input req1,  
    input req2,  
    output reg grant1,  
    output reg grant2,  
    output reg [1:0] active_channel,  
    output reg transfer_complete  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  
    parameter IDLE = 2'b00, CHANNEL1 = 2'b01, CHANNEL2 = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                grant1 = 0;  
                grant2 = 0;  
                transfer_complete = 0;  
                if (req1) begin  
                    next_state = CHANNEL1;  
                end else if (req2) begin  
                    next_state = CHANNEL2;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            CHANNEL1: begin  
                grant1 = 1;  
                grant2 = 0;  
                active_channel = 2'b01;  
                transfer_complete = 1;  
                next_state = IDLE;  
            end  
            CHANNEL2: begin  
                grant1 = 0;  
                grant2 = 1;  
                active_channel = 2'b10;  
                transfer_complete = 1;  
                next_state = IDLE;  
            end  
            default: begin  
                grant1 = 0;  
                grant2 = 0;  
                active_channel = 2'b00;  
                transfer_complete = 0;  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule