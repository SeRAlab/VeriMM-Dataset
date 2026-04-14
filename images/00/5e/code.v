module divider_8bit (  
    input [7:0] dividend,  
    input [7:0] divisor,  
    input start,  
    input clk,  
    input reset,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_quotient;  
    reg [3:0] count;  
    reg state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            temp_dividend <= 8'b0;  
            temp_quotient <= 8'b0;  
            count <= 4'b0;  
            done <= 1'b0;  
            state <= 1'b0;  
        end else begin  
            case (state)  
                1'b0: begin  
                    if (start) begin  
                        temp_dividend <= dividend;  
                        temp_quotient <= 8'b0;  
                        count <= 4'b0;  
                        done <= 1'b0;  
                        state <= 1'b1;  
                    end  
                end  
                1'b1: begin  
                    if (count < 8) begin  
                        if (temp_dividend >= divisor) begin  
                            temp_dividend <= temp_dividend - divisor;  
                            temp_quotient[count] <= 1;  
                        end  
                        count <= count + 1;  
                    end else begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_dividend;  
                        done <= 1'b1;  
                        state <= 1'b0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule