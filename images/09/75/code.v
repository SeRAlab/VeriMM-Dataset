module sata_controller (  
    input clk,  
    input reset,  
    input start,  
    input done,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, TRANSMITTING = 2'b01, WAITING = 2'b10;  

    // Sequential logic for state transitions  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= TRANSMITTING;  
                TRANSMITTING: if (done) state <= WAITING;  
                WAITING: if (start) state <= TRANSMITTING;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule