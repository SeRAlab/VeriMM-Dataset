module top_module(
  input clk,
  input rst,
  input set,
  input d,
  output reg q,   // Change from wire to reg
  output qn
);reg q_i;
  assign qn = ~q_i;

  always @(posedge clk) begin
    if (rst == 1'b0) begin
      q_i <= 1'b0; // Asynchronous reset
    end else if (set == 1'b0) begin
      q_i <= 1'b1; // Asynchronous set
    end else begin
      q_i <= d; // Rising edge triggered
    end
  end

  always @(q_i) begin
    q <= q_i; // Assign the value of q_i to q
  end
  
endmodule