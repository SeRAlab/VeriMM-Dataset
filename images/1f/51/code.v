module nvme_controller (  
    input clk,  
    input reset,  
    input [1:0] command_type, // 00: no command, 01: read, 10: write  
    output reg command_processed  
);  
    reg [1:0] current_state;  
    reg [1:0] next_state;  

    // State encoding  
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  

    // State transition  
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
                if (command_type == 2'b01)  
                    next_state = READ;  
                else if (command_type == 2'b10)  
                    next_state = WRITE;  
                else  
                    next_state = IDLE;  
            end  
            READ: begin  
                next_state = IDLE;  
            end  
            WRITE: begin  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  

    // Output logic  
    always @(posedge clk) begin  
        if (current_state == READ || current_state == WRITE)  
            command_processed <= 1;  
        else  
            command_processed <= 0;  
    end  
endmodule