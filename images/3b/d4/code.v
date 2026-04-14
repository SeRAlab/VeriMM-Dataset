module wifi_fsm(  
    input wire clk,  
    input wire reset,  
    input wire start_connect,  
    output reg [1:0] state  
);  
  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10;  
  
    reg [1:0] next_state;  
    reg [1:0] count;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            count <= 0;  
        end else begin  
            state <= next_state;  
            if (state == CONNECTING) begin  
                count <= count + 1;  
            end else begin  
                count <= 0;  
            end  
        end  
    end  
  
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start_connect)  
                    next_state = CONNECTING;  
                else  
                    next_state = IDLE;  
            end  
            CONNECTING: begin  
                if (count == 2)  
                    next_state = CONNECTED;  
                else  
                    next_state = CONNECTING;  
            end  
            CONNECTED: begin  
                next_state = CONNECTED;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule