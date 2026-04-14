module johnson_counter(
  input clk,
  input rst_n,
  output reg [3:0] johnson_code
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      johnson_code <= 4'b0000;
    end
    else begin
      johnson_code <= {~johnson_code[0], johnson_code[3:1]};
    end
  end

endmodule