module stop_and_wait_arq (  
    input clk,  
    input rst,  
    input send_data,  
    input ack_received,  
    output reg data_out,  
    output reg resend,  
    output reg state  
);  
    // State encoding  
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10, RESEND = 2'b11;  
    reg [1:0] current_state, next_state;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (send_data) begin  
                    data_out = 1;  
                    next_state = SEND;  
                end else begin  
                    data_out = 0;  
                    next_state = IDLE;  
                end  
                resend = 0;  
            end  
            SEND: begin  
                if (ack_received) begin  
                    data_out = 0;  
                    next_state = IDLE;  
                end else begin  
                    data_out = 1;  
                    next_state = WAIT_ACK;  
                end  
                resend = 0;  
            end  
            WAIT_ACK: begin  
                if (ack_received) begin  
                    data_out = 0;  
                    next_state = IDLE;  
                end else begin  
                    data_out = 1;  
                    next_state = RESEND;  
                end  
                resend = 0;  
            end  
            RESEND: begin  
                data_out = 1;  
                next_state = WAIT_ACK;  
                resend = 1;  
            end  
            default: begin  
                next_state = IDLE;  
                data_out = 0;  
                resend = 0;  
            end  
        endcase  
    end  
endmodule