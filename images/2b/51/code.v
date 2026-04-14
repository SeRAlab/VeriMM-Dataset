module divider_4bit (  
    input clk,  
    input rst,  
    input start,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    output reg done  
);  
    reg [3:0] count;  
    reg [3:0] temp_dividend;  
    reg [3:0] temp_quotient;  
    reg state;  
    localparam IDLE = 1'b0, DIVIDE = 1'b1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 4'b0000;  
            remainder <= 4'b0000;  
            done <= 1'b0;  
            count <= 4'b0000;  
            temp_dividend <= 4'b0000;  
            temp_quotient <= 4'b0000;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        temp_dividend <= dividend;  
                        count <= 4'b1000;  
                        temp_quotient <= 4'b0000;  
                        state <= DIVIDE;  
                    end  
                end  
                DIVIDE: begin  
                    if (count > 0) begin  
                        // Shift left  
                        temp_quotient <= {temp_quotient[2:0], 1'b0};  
                        temp_dividend <= {temp_dividend[2:0], 1'b0};  
                        if (temp_dividend >= divisor) begin  
                            temp_dividend <= temp_dividend - divisor;  
                            temp_quotient[0] <= 1'b1;  
                        end  
                        count <= count - 1;  
                    end else begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_dividend;  
                        done <= 1'b1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule