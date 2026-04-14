module top_module(
  input clk,
  input reset,
  input load,
  input up_down,
  output reg [2:0] count,
  output reg max_min_flag
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 3'b000;
      max_min_flag <= 1'b0;
    end else if (load) begin
      count <= 3'b000;
      max_min_flag <= 1'b0;
    end else if (up_down) begin
      if (count == 3'b111) begin
        count <= 3'b000;
        max_min_flag <= 1'b1;
      end else begin
        count <= count + 1;
        max_min_flag <= 1'b0;
      end
    end else begin
      if (count == 3'b000) begin
        count <= 3'b111;
        max_min_flag <= 1'b1;
      end else begin
        count <= count - 1;
        max_min_flag <= 1'b0;
      end
    end
  end

endmodule