module top_module(
  input                clk,
  input                rst_n,
  output reg  [15:0]   Q
);reg [3:0] temp;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q <= 16'b0000000000000000;
      temp <= 4'b0000;
    end else begin
      Q <= {Q[14:0], Q[15] ^ Q[0]};
      temp <= temp + 1;
      if (temp == 4'b1000) begin
        temp <= 4'b0001;
      end
    end
  end

endmodule