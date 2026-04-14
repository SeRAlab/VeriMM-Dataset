module bluetooth_fsm(  
    input clk,  
    input reset,  
    input connect,  
    input disconnect,  
    output reg [1:0] status  
);  
    // State encoding  
    parameter IDLE = 2'b00, CONNECTED = 2'b01, DISCONNECTED = 2'b10;  
    reg [1:0] current_state, next_state;  
    
    // State transition logic  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (connect)  
                    next_state = CONNECTED;  
                else  
                    next_state = IDLE;  
            end  
            CONNECTED: begin  
                if (disconnect)  
                    next_state = DISCONNECTED;  
                else  
                    next_state = CONNECTED;  
            end  
            DISCONNECTED: begin  
                if (connect)  
                    next_state = CONNECTED;  
                else  
                    next_state = DISCONNECTED;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
    
    // State update logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
    
    // Output logic  
    always @(*) begin  
        status = current_state;  
    end  
endmodule