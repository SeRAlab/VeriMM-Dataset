module ARQ_Controller(  
    input clk,  
    input rst,  
    input ack_received,  
    input timeout,  
    output reg send_packet,  
    output reg retransmit,  
    output reg [1:0] state  
);  

    // State Encoding  
    parameter IDLE = 2'b00,  
              SEND = 2'b01,  
              WAIT_ACK = 2'b10,  
              RETRANSMIT = 2'b11;  

    // Initial state  
    initial begin  
        state = IDLE;  
        send_packet = 0;  
        retransmit = 0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            send_packet <= 0;  
            retransmit <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    send_packet <= 0;  
                    retransmit <= 0;  
                    state <= SEND;  
                end  
                SEND: begin  
                    send_packet <= 1;  
                    retransmit <= 0;  
                    state <= WAIT_ACK;  
                end  
                WAIT_ACK: begin  
                    send_packet <= 0;  
                    if (ack_received) begin  
                        state <= IDLE;  
                    end else if (timeout) begin  
                        state <= RETRANSMIT;  
                    end  
                end  
                RETRANSMIT: begin  
                    send_packet <= 1;  
                    retransmit <= 1;  
                    state <= WAIT_ACK;  
                end  
            endcase  
        end  
    end  
endmodule