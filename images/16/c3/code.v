module md5_hash (  
    input wire clk,  
    input wire reset,  
    input wire [127:0] message,  
    output reg [127:0] hash  
);  
    reg [127:0] state;  
    reg [3:0] current_state, next_state;  
    parameter IDLE = 4'b0000, PROCESS = 4'b0001, OUTPUT = 4'b0010;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_state <= IDLE;  
            hash <= 128'b0;  
        end else begin  
            current_state <= next_state;  
        end  
    end  

    always @(*) begin  
        case (current_state)  
            IDLE: if (message) next_state = PROCESS; else next_state = IDLE;  
            PROCESS: begin  
                // Simplified processing of the message (for illustration)  
                state = message ^ 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;  
                next_state = OUTPUT;  
            end  
            OUTPUT: begin  
                hash = state;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule