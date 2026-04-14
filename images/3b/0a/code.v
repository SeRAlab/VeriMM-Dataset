module StopAndWait (  
    input wire clk,  
    input wire rst,  
    input wire send_packet,  
    output reg ack_received,  
    output reg packet_sent  
);  
    reg state;  
    parameter IDLE = 1'b0, SENDING = 1'b1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            packet_sent <= 0;  
            ack_received <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send_packet) begin  
                        packet_sent <= 1;  
                        ack_received <= 0;  
                        state <= SENDING;  
                    end  
                end  
                SENDING: begin  
                    if (ack_received) begin  
                        packet_sent <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule