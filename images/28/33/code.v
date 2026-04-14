module stop_and_wait(clk, reset, send_data, ack, timeout, send_data_out, ack_out, state);  
    input clk, reset, send_data, ack, timeout;  
    output reg send_data_out, ack_out;  
    output reg [1:0] state;  // 2-bit state to represent idle, sending, waiting  

    parameter IDLE = 2'b00;  
    parameter SENDING = 2'b01;  
    parameter WAITING = 2'b10;  

    reg [1:0] next_state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            send_data_out <= 0;  
            ack_out <= 0;  
        end else begin  
            state <= next_state;  
            case (next_state)  
                IDLE: begin  
                    send_data_out <= 0;  
                    ack_out <= 0;  
                end  
                SENDING: begin  
                    send_data_out <= send_data;  
                    ack_out <= 0;  
                end  
                WAITING: begin  
                    send_data_out <= 0;  
                    ack_out <= ack;  
                end  
            endcase  
        end  
    end  

    always @(*) begin  
        case (state)  
            IDLE: next_state = send_data ? SENDING : IDLE;  
            SENDING: next_state = WAITING;  
            WAITING: next_state = (ack) ? IDLE : (timeout ? SENDING : WAITING);  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule