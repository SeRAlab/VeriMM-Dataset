module lfsr (
  input clk,
  input reset,
  input enable,
  output reg [6:0] q
);

  wire feedback = q[6] ^ q[5];
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 7'b0000001;
    end
    else if (enable) begin
      q <= {feedback, q[6:1]};
    end
  end

endmodule