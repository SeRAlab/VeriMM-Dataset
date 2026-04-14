module top_module(
  input clk,
  input we,
  input [13:0] addr,
  input [31:0] din,
  output [31:0] dout
);wire [13:0] addra = addr; // Wire definition corrected, no need to pad with 2 bits

  // Use a different memory primitive or instance that is recognized in your synthesis tool
  // Here, I'm switching to a generic memory module as an example
  // Replace this with the appropriate block memory generator available in your synthesis tool
  (* ram_style = "block" *) reg [31:0] memory_array [0:16383];

  always @(posedge clk) begin
    if (we) begin
      memory_array[addra] <= din; // Write operation
    end
  end

  assign dout = memory_array[addra]; // Read operation

endmodule