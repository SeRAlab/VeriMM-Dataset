module top_module(
    input wire [31:0] srca, 
    input wire [31:0] srcb, 
    input wire [1:0] alucontrol, 
    output reg [31:0] aluresult, 
    output reg [3:0] aluflags
);reg [31:0] sum;
  reg cout;
  wire [31:0] srcbc = ~srcb;
  wire xa;

  // Replace the xor3 instance with a simple XOR operation
  assign xa = alucontrol[0] ^ srca[31] ^ srcb[31];

  always @(*) begin
    // Perform addition or subtraction based on value of alucontrol[0]
    if (alucontrol[0]) begin
      {cout, sum} = srca + srcbc + 1;
    end else begin
      {cout, sum} = srca + srcb;
    end
    
    // Set aluresult based on value of alucontrol
    case (alucontrol)
      2'b00: aluresult = sum;     // Addition
      2'b01: aluresult = sum;     // Subtraction
      2'b10: aluresult = srca & srcb; // And operation
      2'b11: aluresult = srca | srcb; // Or operation
    endcase
    
    // Set aluflags
    aluflags[3:2] = {aluresult[31], aluresult == 0}; // Set n and z flags
    aluflags[1] = cout & ~alucontrol[1]; // Set c flag
    aluflags[0] = xa & (~alucontrol[1] & (aluresult[31] ^ srca[31])); // Set v flag
  end

endmodule