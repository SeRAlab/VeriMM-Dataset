module sliding_window_protocol #(parameter WINDOW_SIZE = 4) (  
    input wire clk,  
    input wire reset,  
    input wire send_packet,  
    input wire ack_received,  
    output reg [3:0] window_start,  
    output reg [3:0] window_end,  
    output reg send_enable  
);  
    reg [3:0] current_packet;  
    reg [1:0] state; // 0: IDLE, 1: SENDING, 2: WAITING_ACK  
    localparam IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            window_start <= 0;  
            window_end <= 0;  
            send_enable <= 0;  
            current_packet <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send_packet) begin  
                        state <= SENDING;  
                        current_packet <= window_start;  
                        send_enable <= 1;  
                    end  
                end  
                SENDING: begin  
                    if (current_packet < window_start + WINDOW_SIZE) begin  
                        current_packet <= current_packet + 1;  
                    end else begin  
                        state <= WAITING_ACK;  
                        send_enable <= 0;  
                    end  
                end  
                WAITING_ACK: begin  
                    if (ack_received && (window_start < current_packet)) begin  
                        window_start <= window_start + 1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule