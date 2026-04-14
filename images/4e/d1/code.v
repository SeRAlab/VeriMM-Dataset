module top_module(clk, rst, load, D1, D2, Q);input clk, rst, load;
  input [1:0] D1, D2;
  output reg [1:0] Q;
  wire [1:0] sum;
  wire carry;

  // Calculate the sum
  assign sum[0] = D1[0] ^ D2[0];
  assign sum[1] = D1[1] ^ D2[1];

  // Calculate the carry (not used in this simple adder)
  assign carry = (D1[0] & D2[0]) | (D1[1] & D2[1]);

  // Update Q on clock edge
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      Q <= 2'b00; // Reset Q to 0 on reset signal
    end else if (load) begin
      Q <= sum; // Load the calculated sum when load is high
    end
  end
endmodule