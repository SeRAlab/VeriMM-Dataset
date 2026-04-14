module top_module(clk, rst, load, D, Q);input clk, rst, load;
  input [11:0] D;
  output reg [11:0] Q;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Q <= 12'b0;  // Reset Q to zero on reset signal
    end else begin
      if (load) begin
        Q <= D;    // Load D into Q if load is asserted
      end 
      // No need for an else here because Q retains its value by default
    end
  end

endmodule