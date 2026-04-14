module binary_counter (
  input clk,
  input reset,
  input enable,
  output reg [7:0] count,
  output reg terminal_count
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 8'b00000000;
      terminal_count <= 1'b0;
    end
    else if (enable) begin
      if (count == 8'b11111111) begin
        count <= 8'b00000000;
        terminal_count <= 1'b1;
      end else begin
        count <= count + 1'b1;
        terminal_count <= 1'b0;
      end
    end
  end

endmodule