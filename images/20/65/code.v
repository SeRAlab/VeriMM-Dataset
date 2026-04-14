module divider_8bit(clk, reset, start, dividend, divisor, quotient, remainder, done);  
  input clk, reset, start;  
  input [7:0] dividend, divisor;  
  output reg [7:0] quotient, remainder;  
  output reg done;  

  reg [7:0] temp_dividend;  
  reg [7:0] temp_divisor;  
  reg [3:0] count;  
  reg state;  

  parameter IDLE = 1'b0, DIVIDE = 1'b1;  

  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      quotient <= 8'b0;  
      remainder <= 8'b0;  
      done <= 1'b0;  
      count <= 4'b0;  
      state <= IDLE;  
    end else begin  
      case (state)  
        IDLE: begin  
          if (start) begin  
            temp_dividend <= dividend;  
            temp_divisor <= divisor;  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            count <= 4'b0;  
            if (divisor == 8'b0) begin  
              done <= 1'b1;  
            end else begin  
              state <= DIVIDE;  
            end  
          end  
        end  
        DIVIDE: begin  
          if (count < 8) begin  
            remainder <= {remainder[6:0], temp_dividend[7]};  
            temp_dividend <= {temp_dividend[6:0], 1'b0};  
            if (remainder >= temp_divisor) begin  
              remainder <= remainder - temp_divisor;  
              quotient <= {quotient[6:0], 1'b1};  
            end else begin  
              quotient <= {quotient[6:0], 1'b0};  
            end  
            count <= count + 1;  
          end else begin  
            done <= 1'b1;  
            state <= IDLE;  
          end  
        end  
      endcase  
    end  
  end  
endmodule