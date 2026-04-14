module top_module(
  input clk,
  input reset,
  input load,
  input up_down,
  output reg [3:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0000;
    end else begin
      if (load) begin
        count <= count;
      end else begin
        if (up_down) begin
          count <= count + 1;
        end else begin
          count <= count - 1;
        end
      end
    end
  end

endmodule