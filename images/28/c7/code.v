module Reed_Solomon_Encoder(  
    input clk,  
    input reset,  
    input [7:0] message,  
    input start,  
    output reg [14:0] codeword,  
    output reg done  
);  
    reg [3:0] state;  
    reg [3:0] next_state;  
    parameter IDLE = 0, LOAD = 1, ENCODE = 2, FINISH = 3;  
    reg [7:0] data_in;  
    reg [14:0] temp_codeword;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            codeword <= 15'b0;  
            done <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start)  
                    next_state = LOAD;  
                else  
                    next_state = IDLE;  
            end  
            LOAD: begin  
                data_in = message;  
                next_state = ENCODE;  
            end  
            ENCODE: begin  
                // Simple encoding logic for demo purposes  
                temp_codeword = {data_in, data_in ^ 8'hFF}; // XOR for redundancy  
                next_state = FINISH;  
            end  
            FINISH: begin  
                codeword = temp_codeword;  
                done = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule