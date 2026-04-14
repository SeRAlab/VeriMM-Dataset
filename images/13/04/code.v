module restoring_divider(clk, reset, start, dividend, divisor, quotient, remainder, done);  
    input clk, reset, start;  
    input [3:0] dividend;  
    input [3:0] divisor;  
    output reg [3:0] quotient;  
    output reg [3:0] remainder;  
    output reg done;  

    reg [3:0] count;  
    reg [7:0] temp;  
    reg state;  

    parameter IDLE = 1'b0, DIVIDE = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 4'b0;  
            temp <= 8'b0;  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            done <= 1'b0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        temp <= {dividend, 4'b0};  
                        quotient <= 4'b0;  
                        count <= 4'b0;  
                        state <= DIVIDE;  
                        done <= 1'b0;  
                    end  
                end  
                DIVIDE: begin  
                    if (count < 4) begin  
                        temp <= {temp[6:0], 1'b0};  
                        if (temp[7:4] >= divisor) begin  
                            temp[7:4] <= temp[7:4] - divisor;  
                            temp[3:0] <= temp[3:0] | 4'b0001;  
                        end  
                        count <= count + 1;  
                    end else begin  
                        quotient <= temp[3:0];  
                        remainder <= temp[7:4];  
                        done <= 1'b1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule