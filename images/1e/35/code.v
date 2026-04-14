module ARQ_System (  
    input clk,  
    input reset,  
    input data_in,  
    input ack_nack,  
    output reg data_out  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;  
   
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
                    state <= WAIT_ACK;  
                end  
                WAIT_ACK: begin  
                    if (ack_nack) begin  
                        state <= IDLE; // ACK received, go to IDLE state  
                    end else begin  
                        data_out <= data_out; // Resend data  
                    end  
                end  
            endcase  
        end  
    end  
endmodule