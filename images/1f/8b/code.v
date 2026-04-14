module sliding_window_protocol(  
    input wire clk,  
    input wire reset,  
    input wire send_frame,  
    input wire ack_frame,  
    output reg [3:0] sent_frames,  
    output reg [3:0] acknowledged_frames,  
    output reg timeout  
);  

    reg [1:0] state;  
    reg [1:0] next_state;  
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;  

    initial begin  
        sent_frames = 4'd0;  
        acknowledged_frames = 4'd0;  
        timeout = 1'b0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            sent_frames <= 4'd0;  
            acknowledged_frames <= 4'd0;  
            timeout <= 1'b0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (send_frame) begin  
                    next_state = SENDING;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            SENDING: begin  
                sent_frames = sent_frames + 1;  
                next_state = WAITING_ACK;  
            end  
            WAITING_ACK: begin  
                if (ack_frame) begin  
                    acknowledged_frames = acknowledged_frames + 1;  
                    next_state = IDLE;  
                end else begin  
                    timeout = 1'b1;  
                    next_state = SENDING;  
                end  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule