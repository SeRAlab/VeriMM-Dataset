module sliding_window_protocol(  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    output reg [3:0] sent_packets,  
    output reg [3:0] acked_packets  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            sent_packets <= 4'b0000;  
            acked_packets <= 4'b0000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (send && sent_packets < 4'b0100) begin  
                        sent_packets <= sent_packets + 1;  
                        state <= SENDING;  
                    end  
                end  
                SENDING: begin  
                    if (acked_packets < sent_packets) begin  
                        state <= WAITING_ACK;  
                    end  
                end  
                WAITING_ACK: begin  
                    if (ack) begin  
                        acked_packets <= acked_packets + 1;  
                        if (acked_packets + 1 == sent_packets) begin  
                            state <= IDLE;  
                        end  
                    end  
                end  
            endcase  
        end  
    end  
endmodule