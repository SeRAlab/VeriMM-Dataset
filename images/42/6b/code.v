module top_module(A, B, CLK, Y);input [3:0] A;
  input [3:0] B;
  input CLK;
  output reg [7:0] Y;
  reg [7:0] P; // Changed P to 8 bits to hold the full product
  reg [2:0] count;

  always @(posedge CLK) begin
    if (count == 0) begin
      P <= 8'b00000000; // Initialize P to 0
      Y <= 8'b00000000; // Initialize Y to 0
      count <= 1; // Initialize count
    end else if (count == 1) begin
      if (B[0] == 1) P <= A; // Adding A if respective bit in B is 1
      count <= count + 1;
    end else if (count == 2) begin
      if (B[1] == 1) P <= P + (A << 1); // Shift A left by 1 for the second bit
      count <= count + 1;
    end else if (count == 3) begin
      if (B[2] == 1) P <= P + (A << 2); // Shift A left by 2 for the third bit
      count <= count + 1;
    end else if (count == 4) begin
      if (B[3] == 1) P <= P + (A << 3); // Shift A left by 3 for the fourth bit
      Y <= P; // Output the result at the end
      count <= 0; // Reset count
    end
  end
endmodule