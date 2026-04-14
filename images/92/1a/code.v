module top_module(
  input clk,
  input areset,
  input dir,
  output reg [2:0] count,
  output reg cout
);always @(posedge clk or negedge areset) begin
    if (areset == 0) begin
      count <= 3'b0;
      cout <= 1'b0;
    end else begin
      if (dir == 1) begin
        if (count == 3'b111) begin
          count <= 3'b000;
          cout <= 1'b1;
        end else begin
          count <= count + 1;
          cout <= 1'b0;
        end
      end else begin
        if (count == 3'b000) begin
          count <= 3'b111;
          cout <= 1'b1;
        end else begin
          count <= count - 1;
          cout <= 1'b0;
        end
      end
    end
  end

endmodule