module stop_and_wait_arq(  
    input clk,  
    input rst_n,  
    input send_data,  
    input ack,  
    output reg data_out,  
    output reg resend  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            state <= IDLE;  
            data_out <= 0;  
            resend <= 0;  
        end  
        else begin  
            case (state)  
                IDLE: begin  
                    if (send_data) begin  
                        data_out <= 1;  
                        resend <= 0;  
                        state <= SEND;  
                    end  
                end  
                SEND: begin  
                    state <= WAIT_ACK;  
                end  
                WAIT_ACK: begin  
                    if (ack) begin  
                        data_out <= 0;  
                        state <= IDLE;  
                    end  
                    else begin  
                        resend <= 1;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule