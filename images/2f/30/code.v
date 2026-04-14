module restoring_divider(clk, rst, start, dividend, divisor, quotient, remainder, done);  
  input clk;  
  input rst;  
  input start;  
  input [3:0] dividend;  
  input [3:0] divisor;  
  output reg [3:0] quotient;  
  output reg [3:0] remainder;  
  output reg done;  
  
  reg [3:0] temp_dividend;  
  reg [4:0] temp;  
  reg [2:0] count;  
  reg state;  
  
  parameter IDLE = 1'b0, DIVIDE = 1'b1;  
  
  always @(posedge clk or posedge rst) begin  
    if (rst) begin  
      quotient <= 4'b0;  
      remainder <= 4'b0;  
      temp_dividend <= 4'b0;  
      count <= 3'b0;  
      done <= 1'b0;  
      state <= IDLE;  
    end  
    else begin  
      case (state)  
        IDLE: begin  
          if (start) begin  
            temp_dividend <= dividend;  
            quotient <= 4'b0;  
            remainder <= 4'b0;  
            count <= 3'b0;  
            state <= DIVIDE;  
            done <= 1'b0;  
          end  
        end  
        DIVIDE: begin  
          if (count < 4) begin  
            temp = {remainder, temp_dividend[3]};  
            remainder = temp - divisor;  
            if (remainder[4]) begin  
              remainder = temp;  
              quotient[count] = 1'b0;  
            end  
            else begin  
              quotient[count] = 1'b1;  
            end  
            temp_dividend = temp_dividend << 1;  
            count = count + 1;  
          end  
          else begin  
            done <= 1'b1;  
            state <= IDLE;  
          end  
        end  
      endcase  
    end  
  end  
endmodule