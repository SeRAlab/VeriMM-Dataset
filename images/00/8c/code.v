module ARQ_Controller(  
    input clk,  
    input reset,  
    input data_in,  
    input ack_nack,  
    output reg data_out  
);  
    reg [1:0] state; // 00: IDLE, 01: SEND, 10: RESEND  
    parameter IDLE = 2'b00, SEND = 2'b01, RESEND = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            data_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    data_out <= data_in;  
                    state <= SEND;  
                end  
                SEND: begin  
                    if (ack_nack) begin // ACK received  
                        state <= IDLE;  
                    end else begin // NACK received  
                        state <= RESEND;  
                    end  
                end  
                RESEND: begin  
                    data_out <= data_in;  
                    state <= SEND;  
                end  
            endcase  
        end  
    end  
endmodule