module ARQ_System (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input parity_in,  
    output reg ack,  
    output reg req  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, CHECK_PARITY = 4'b0001, ACK = 4'b0010, REQ = 4'b0011;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ack <= 0;  
            req <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack <= 0;  
                    req <= 0;  
                    state <= CHECK_PARITY;  
                end  
                CHECK_PARITY: begin  
                    if (^data_in === parity_in) begin  
                        state <= ACK;  
                    end else begin  
                        state <= REQ;  
                    end  
                end  
                ACK: begin  
                    ack <= 1;  
                    state <= IDLE;  
                end  
                REQ: begin  
                    req <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule