module restoring_divider (  
    input clk,  
    input reset,  
    input start,  
    input [3:0] dividend,  
    input [1:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  

    reg [3:0] temp_dividend;  
    reg [1:0] temp_divisor;  
    reg [2:0] state;  
    reg [2:0] next_state;  

    localparam IDLE = 3'b000,  
               SUBTRACT = 3'b001,  
               SHIFT = 3'b010,  
               DONE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        case(state)  
            IDLE: begin  
                if(start) begin  
                    temp_dividend = dividend;  
                    temp_divisor = divisor;  
                    quotient = 0;  
                    next_state = SUBTRACT;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            SUBTRACT: begin  
                if(temp_dividend >= temp_divisor) begin  
                    temp_dividend = temp_dividend - temp_divisor;  
                    quotient = quotient + 1;  
                    next_state = SHIFT;  
                end else begin  
                    next_state = DONE;  
                end  
            end  
            SHIFT: begin  
                temp_dividend = {temp_dividend[2:0], 1'b0};  
                next_state = SUBTRACT;  
            end  
            DONE: begin  
                remainder = temp_dividend;  
                done = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule