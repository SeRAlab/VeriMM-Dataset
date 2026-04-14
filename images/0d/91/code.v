module ARQ_System (  
    input clk,  
    input rst,  
    input [4:0] data_in,  
    input parity_in,  
    output reg [4:0] data_out,  
    output reg ack  
);  

    reg [1:0] state;  
    reg [1:0] next_state;  

    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10, RESEND = 2'b11;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                next_state = SEND;  
                ack = 0;  
            end  
            SEND: begin  
                data_out = data_in;  
                next_state = WAIT_ACK;  
                ack = 0;  
            end  
            WAIT_ACK: begin  
                if (parity_in == ^data_out)  
                    next_state = IDLE;  
                else  
                    next_state = RESEND;  
                ack = 1;  
            end  
            RESEND: begin  
                data_out = data_in;  
                next_state = WAIT_ACK;  
                ack = 0;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule