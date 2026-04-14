module sliding_window_controller(  
    input clk,  
    input rst,  
    input ack_received,  
    output reg [1:0] current_state  
);  
    parameter WAIT = 2'b00, SEND = 2'b01, ACK = 2'b10;  
    reg [1:0] next_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            current_state <= WAIT;  
        else  
            current_state <= next_state;  
    end  

    always @(*) begin  
        case (current_state)  
            WAIT: begin  
                if (ack_received)  
                    next_state = SEND;  
                else  
                    next_state = WAIT;  
            end  
            SEND: begin  
                next_state = ACK;  
            end  
            ACK: begin  
                next_state = WAIT;  
            end  
            default: next_state = WAIT;  
        endcase  
    end  
endmodule