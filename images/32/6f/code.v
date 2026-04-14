module sliding_window_controller(  
    input wire clk,  
    input wire rst,  
    input wire send_frame,  
    input wire ack_received,  
    output reg [1:0] current_state, // 00: idle, 01: sending, 10: waiting  
    output reg [3:0] frames_sent // tracks number of frames sent  
);  
    // State encoding
    parameter IDLE = 2'b00;  
    parameter SENDING = 2'b01;  
    parameter WAITING = 2'b10;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_state <= IDLE;  
            frames_sent <= 4'b0000;  
        end else begin  
            case (current_state)  
                IDLE: begin  
                    if (send_frame) begin  
                        current_state <= SENDING;  
                    end  
                end  
                SENDING: begin  
                    if (frames_sent < 4) begin  
                        frames_sent <= frames_sent + 1;  
                    end else begin  
                        current_state <= WAITING;  
                    end  
                end  
                WAITING: begin  
                    if (ack_received) begin  
                        current_state <= IDLE;  
                        frames_sent <= 4'b0000;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule