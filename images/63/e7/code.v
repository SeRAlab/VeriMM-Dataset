module top_module(data_out, data_in, wraddr, rdaddr, wren, clk);// Define constants for the register file
  parameter DEPTH = 8;
  parameter WIDTH = 8;
  
  // Declare input/output signals
  input [WIDTH-1:0] data_in;
  input [DEPTH-1:0] wraddr, rdaddr;
  input wren, clk;
  output reg [WIDTH-1:0] data_out;
  
  // Declare the register file as a multi-dimensional array of registers
  reg [WIDTH-1:0] reg_file [DEPTH-1:0];
  
  // Write and read operations for the register file
  always @(posedge clk) begin
    if (wren) begin
      reg_file[wraddr] <= data_in;
    end
    else begin
      data_out <= reg_file[rdaddr];
    end
  end
  
endmodule