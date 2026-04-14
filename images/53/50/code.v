module top_module(
  input clk, // clock signal
  input reset, // asynchronous reset signal
  input [1:0] mode, // 0 for unsigned, 1 for signed
  input signed [29:0] a, // first 30-bit register
  input signed [29:0] b, // second 30-bit register
  output signed [29:0] sum, // 30-bit register containing the sum
  output reg [3:0] flags // 4-bit signal indicating overflow/underflow
);reg signed [29:0] a_reg; // register to hold value of a
  reg signed [29:0] b_reg; // register to hold value of b
  reg signed [29:0] sum_reg; // register to hold value of sum
  reg [1:0] mode_reg; // register to hold value of mode
  reg [3:0] flags_reg; // register to hold value of flags
  
  always @(posedge clk) begin
    if (reset) begin
      a_reg <= 0;
      b_reg <= 0;
      sum_reg <= 0;
      mode_reg <= 0;
      flags_reg <= 0;
    end else begin
      a_reg <= a;
      b_reg <= b;
      mode_reg <= mode;
      
      if (mode_reg == 0) begin // unsigned addition
        sum_reg <= a_reg + b_reg;
        if (sum_reg > 2**30 - 1) begin // overflow
          flags_reg <= 4'b0001;
        end else begin
          flags_reg <= 4'b0000;
        end
      end else begin // signed addition
        sum_reg <= $signed(a_reg) + $signed(b_reg);
        if (sum_reg > 2**29 - 1 || sum_reg < -2**29) begin // overflow or underflow
          flags_reg <= 4'b0010;
        end else begin
          flags_reg <= 4'b0000;
        end
      end
    end
  end
  
  assign sum = sum_reg;
  assign flags = flags_reg;
  
endmodule