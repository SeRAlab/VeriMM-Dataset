module top_module( input clk, input d, output q );reg [2:0] reg_out;
  wire [2:0] reg_in;

  // Master-slave D flip-flop
  always @(posedge clk) begin
    reg_out <= reg_in;
  end

  // Pipeline structure
  assign reg_in = {reg_out[1:0], d};

  assign q = reg_out[2];

endmodule