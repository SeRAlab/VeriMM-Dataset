module top_module(
  input                clk,              // Clock input for Johnson counter
  input                reset,            // Synchronous active-high reset input for Johnson counter
  input [49:0]         in,               // 50-inputs for the combinational circuit
  output reg           out_nand,         // Output of 50-input NAND gate in combinational circuit
  output reg           out_nor,          // Output of 50-input NOR gate in combinational circuit
  output reg           out_xnor          // Output of functional module
);// Johnson counter module from problem 2
  reg [63:0] johnson_counter;
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      johnson_counter <= 64'h1;
    end else begin
      johnson_counter <= {johnson_counter[62:0], ~johnson_counter[63]};
    end
  end
  
  // Combinational circuit module from problem 1
  wire [49:0] nand_inputs;
  assign nand_inputs = in;
  wire [49:0] nor_inputs;
  assign nor_inputs = in;
  assign out_nand = ~&nand_inputs;
  assign out_nor = ~|nor_inputs;
  
  // Functional module to produce XOR of three inputs
  always @(posedge clk) begin
    out_xnor <= johnson_counter[63] ^ out_nand ^ out_nor;
  end

endmodule