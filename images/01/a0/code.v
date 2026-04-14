module nvme_controller(  
    input wire clk,  
    input wire reset,  
    input wire command,  
    output reg [1:0] current_state  
);  
    // State encoding  
    parameter IDLE = 2'b00, PROCESSING = 2'b01, DONE = 2'b10;  

    // State Transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else begin  
            case (current_state)  
                IDLE: if (command) current_state <= PROCESSING;  
                PROCESSING: current_state <= DONE;  
                DONE: current_state <= IDLE;  
                default: current_state <= IDLE;  
            endcase  
        end  
    end  
endmodule