module ARQ_System(  
    input wire clk,  
    input wire reset,  
    input wire send_data,  
    input wire ack,  
    output reg retransmit,  
    output reg data_sent  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00,  
              SENDING = 2'b01,  
              WAITING_ACK = 2'b10;  
              
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            retransmit <= 0;  
            data_sent <= 0;  
        end  
        else begin  
            case (state)  
                IDLE: begin  
                    if (send_data) begin  
                        data_sent <= 1;  
                        retransmit <= 0;  
                        state <= SENDING;  
                    end  
                end  
                SENDING: begin  
                    if (ack) begin  
                        data_sent <= 0;  
                        state <= IDLE;  
                    end  
                    else begin  
                        retransmit <= 1;  
                        state <= WAITING_ACK;  
                    end  
                end  
                WAITING_ACK: begin  
                    if (ack) begin  
                        data_sent <= 0;  
                        retransmit <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule