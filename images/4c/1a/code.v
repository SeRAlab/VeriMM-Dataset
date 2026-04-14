module top_module( input clk, input d, output q );reg [2:0] register;
  wire [2:0] next_register;

  assign next_register = {register[1:0], d};

  always @(posedge clk) begin
    register <= next_register;
  end

  assign q = register[2];

endmodule