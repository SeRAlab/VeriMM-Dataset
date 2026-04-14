module top_module( input clk, input d, output q );reg [2:0] pipeline;

  always @(posedge clk) begin
    pipeline <= {pipeline[1:0], d};
  end

  assign q = pipeline[2];

endmodule