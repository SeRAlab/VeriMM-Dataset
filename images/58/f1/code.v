module top_module(
  input                clk,
  input                rst_n,
  output reg  [3:0]    Q
);wire [5:0] temp;

  assign temp = {Q[3], Q[2], Q[1], Q[0], Q[3], Q[2]};

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q <= 4'b0000;
    end else begin
      Q <= {temp[4], temp[5], temp[3], temp[2]};
    end
  end

endmodule