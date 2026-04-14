module divider_4bit(  
    input wire clk,  
    input wire [3:0] dividend,  
    input wire [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    input wire start,  
    output reg done  
);  
    reg [3:0] temp_dividend;  
    reg [3:0] temp_divisor;  
    reg [2:0] state;  
    parameter IDLE = 3'b000, DIVIDE = 3'b001, DONE = 3'b010;  

    always @(posedge clk) begin  
        case(state)  
            IDLE: begin  
                if(start) begin  
                    temp_dividend <= dividend;  
                    temp_divisor <= divisor;  
                    quotient <= 0;  
                    remainder <= 0;  
                    state <= DIVIDE;  
                    done <= 0;  
                end  
            end  
            DIVIDE: begin  
                if(temp_dividend >= temp_divisor) begin  
                    temp_dividend <= temp_dividend - temp_divisor;  
                    quotient <= quotient + 1;  
                end else begin  
                    remainder <= temp_dividend;  
                    state <= DONE;  
                end  
            end  
            DONE: begin  
                done <= 1;  
                state <= IDLE;  
            end  
            default: state <= IDLE;  
        endcase  
    end  
endmodule