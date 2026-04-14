module binary_counter (
  input clk,
  input ctrl,
  input [3:0] load_data,
  output reg [3:0] count,
  output reg flag
);

  always @(posedge clk) begin
    if (ctrl == 1) begin
      count <= load_data;
      flag <= 0;
    end else begin
      if (count == 4'b1111) begin
        count <= 4'b0000;
        flag <= 1;
      end else begin
        count <= count + 1;
        flag <= 0;
      end
    end
  end

endmodule
