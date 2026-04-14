module top_module(clk, rst, load, D, Q);input [1:0] D;
  output Q;
  input clk, rst, load;
  wire n1, n3, n2;

  // Replace unknown module types with standard Verilog constructs
  reg Q_reg; // Register to hold the output value

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q_reg <= 1'b0; // Asynchronous reset
    end else if (load) begin
      Q_reg <= D[0]; // Load input D[0] into register if load is active
    end
  end

  assign Q = Q_reg; // Connect internal register to output

endmodule