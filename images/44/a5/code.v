module top_module(
  input clk,
  input reset,
  input [7:0] a,
  input [7:0] b,
  output reg [15:0] result
);reg [8:0] multiplier;
  reg [8:0] multiplicand;
  reg [3:0] counter;
  reg [8:0] addend;
  reg [1:0] control;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      multiplier <= 0;
      multiplicand <= 0;
      counter <= 0;
      addend <= 0;
      control <= 0;
      result <= 0;
    end
    else begin
      multiplier <= {1'b0, a};
      multiplicand <= {1'b0, b};
      
      case (control)
        2'b00: begin
          addend <= 0;
        end
        2'b01: begin
          addend <= multiplicand;
        end
        2'b10: begin
          addend <= ~multiplicand + 1;
        end
        2'b11: begin
          addend <= 0;
        end
      endcase
      
      if (counter == 0) begin
        control <= 2'b00;
      end
      else if (multiplier[0] == 1 && counter != 1) begin
        control <= 2'b10;
      end
      else if (multiplier[1] == 0) begin
        control <= 2'b00;
      end
      else begin
        control <= 2'b01;
      end
      
      if (control == 2'b01) begin
        result <= result + addend;
      end
      
      multiplier <= {multiplier[8], multiplier[8:1]};
      counter <= counter - 1;
    end
  end
endmodule