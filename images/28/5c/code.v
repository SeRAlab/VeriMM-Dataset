module stop_and_wait (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    input send,  
    output reg ack,  
    output reg [3:0] data_out  
);  

    reg [1:0] state;  
    reg [1:0] next_state;  

    parameter IDLE = 2'b00;  
    parameter SEND = 2'b01;  
    parameter WAIT_ACK = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(state or send or ack) begin  
        case (state)  
            IDLE: begin  
                if (send) begin  
                    next_state = SEND;  
                    ack = 0;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            SEND: begin  
                next_state = WAIT_ACK;  
                data_out = data_in;  
            end  
            WAIT_ACK: begin  
                if (ack) begin  
                    next_state = IDLE;  
                end else begin  
                    next_state = WAIT_ACK;  
                end  
            end  
            default: next_state = IDLE;  
        endcase  
    end  

    always @(posedge clk) begin  
        if (state == WAIT_ACK)  
            ack <= 1;  
    end  
endmodule