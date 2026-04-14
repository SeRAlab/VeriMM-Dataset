module divider_4bit (  
    input clk,  
    input rst,  
    input [3:0] numerator,  
    input [3:0] denominator,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg error  
);  

    reg [3:0] temp_numerator;  
    reg [3:0] temp_denominator;  
    reg [2:0] state;  
    parameter IDLE = 3'b000, DIVIDE = 3'b001, OUTPUT = 3'b010, ERROR = 3'b011;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
            error <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (denominator != 0) begin  
                        temp_numerator <= numerator;  
                        temp_denominator <= denominator;  
                        quotient <= 0;  
                        state <= DIVIDE;  
                        error <= 0;  
                    end else begin  
                        state <= ERROR;  
                        error <= 1;  
                    end  
                end  
                DIVIDE: begin  
                    if (temp_numerator >= temp_denominator) begin  
                        temp_numerator <= temp_numerator - temp_denominator;  
                        quotient <= quotient + 1;  
                    end else begin  
                        remainder <= temp_numerator;  
                        state <= OUTPUT;  
                    end  
                end  
                OUTPUT: begin  
                    state <= IDLE;  
                end  
                ERROR: begin  
                    quotient <= 4'b1111;  
                    remainder <= 4'b1111;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule