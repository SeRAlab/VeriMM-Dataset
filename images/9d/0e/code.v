module ring_counter(
  input clk,
  input rst_n,
  output reg [4:0] ring_code
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      ring_code <= 5'b00001;
    end
    else begin
      ring_code <= {ring_code[3:0], ring_code[4]};
    end
  end

endmodule