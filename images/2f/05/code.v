module stop_and_wait(  
    input wire clk,  
    input wire reset,  
    input wire send,  
    input wire ack,  
    output reg frame_sent,  
    output reg frame_received  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00;  
    parameter WAIT_ACK = 2'b01;  
    parameter SEND_FRAME = 2'b10;  
    parameter RECEIVED = 2'b11;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            frame_sent <= 0;  
            frame_received <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send) begin  
                        frame_sent <= 1;  
                        state <= SEND_FRAME;  
                    end  
                end  
                SEND_FRAME: begin  
                    if (ack) begin  
                        frame_received <= 1;  
                        state <= WAIT_ACK;  
                    end  
                end  
                WAIT_ACK: begin  
                    if (send) begin  
                        frame_sent <= 1;  
                        frame_received <= 0;  
                        state <= SEND_FRAME;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule