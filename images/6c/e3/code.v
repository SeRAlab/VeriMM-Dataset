module synchronous_counter (
  input clk,
  input enable,
  input load,
  input [3:0] value,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (load) begin
      count <= value;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule