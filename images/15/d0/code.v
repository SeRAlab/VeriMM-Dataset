module arq_protocol(  
    input clk,  
    input reset,  
    input ack,  
    input [4:0] data_in,  
    output reg [4:0] data_out,  
    output reg resend  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            resend <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    data_out <= data_in;  
                    resend <= 0;  
                    state <= SEND;  
                end  
                SEND: begin  
                    if (ack) begin  
                        state <= IDLE;  
                    end else begin  
                        resend <= 1;  
                        state <= WAIT_ACK;  
                    end  
                end  
                WAIT_ACK: begin  
                    if (ack) begin  
                        resend <= 0;  
                        state <= IDLE;  
                    end else begin  
                        resend <= 1;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule