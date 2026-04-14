module bluetooth_fsm (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire connect,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, SCAN = 2'b01, CONNECT = 2'b10;  
    reg [1:0] next_state;  

    // Sequential logic for state transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    // Combinational logic for next state  
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start)  
                    next_state = SCAN;  
                else  
                    next_state = IDLE;  
            end  
            SCAN: begin  
                if (connect)  
                    next_state = CONNECT;  
                else  
                    next_state = SCAN;  
            end  
            CONNECT: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule