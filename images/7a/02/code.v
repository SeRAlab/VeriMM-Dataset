module johnson_counter(
  input clk,
  input rst_n,
  output reg [3:0] johnson_count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      johnson_count <= 4'b0000;
    end
    else begin
      johnson_count <= {~johnson_count[3], johnson_count[3:1]};
    end
  end

endmodule