module restoring_divider(input [4:0] dividend, input [2:0] divisor, input start, input clk, input rst,  
                         output reg [4:0] quotient, output reg [4:0] remainder, output reg done);  
    reg [4:0] temp_dividend;  
    reg [2:0] count;  
    reg [4:0] temp_quotient;  
    reg [1:0] state;  
      
    parameter IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 5'b0;  
            remainder <= 5'b0;  
            temp_dividend <= 5'b0;  
            temp_quotient <= 5'b0;  
            count <= 3'b0;  
            done <= 1'b0;  
            state <= IDLE;  
        end else begin  
            case(state)  
                IDLE: begin  
                    if (start) begin  
                        temp_dividend <= dividend;  
                        temp_quotient <= 5'b0;  
                        count <= 3'b101; // 5 bits for dividend  
                        state <= DIVIDE;  
                        done <= 1'b0;  
                    end  
                end  
                DIVIDE: begin  
                    if (count > 0) begin  
                        temp_dividend <= {temp_dividend[4:0], 1'b0}; // Shift left  
                        temp_quotient <= {temp_quotient[3:0], 1'b0};  
                        temp_dividend <= temp_dividend - {2'b00, divisor};  
                  
                        if (temp_dividend[4]) begin  
                            temp_dividend <= temp_dividend + {2'b00, divisor}; // Restore  
                        end else begin  
                            temp_quotient[0] <= 1'b1; // Set the LSB of quotient  
                        end  
                        count <= count - 1;  
                    end else begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_dividend;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    done <= 1'b1;  
                end  
            endcase  
        end  
    end  
endmodule