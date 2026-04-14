module i2c_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire stop,  
    input wire read,  
    input wire write,  
    output reg ack,  
    output reg state  
);  

    // State encoding  
    parameter IDLE = 3'b000,  
              START = 3'b001,  
              STOP = 3'b010,  
              READ = 3'b011,  
              WRITE = 3'b100;  

    reg [2:0] current_state, next_state;  

    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  

    // Next state logic  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (start)  
                    next_state = START;  
                else  
                    next_state = IDLE;  
            end  
            START: begin  
                next_state = (write) ? WRITE : (read) ? READ : STOP;  
            end  
            WRITE: begin  
                ack = 1;  
                next_state = STOP;  
            end  
            READ: begin  
                ack = 0;  
                next_state = STOP;  
            end  
            STOP: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  

    // Output logic  
    always @(current_state) begin  
        case (current_state)  
            WRITE: ack = 1;  
            READ: ack = 0;  
            default: ack = 0;  
        endcase  
    end  

endmodule