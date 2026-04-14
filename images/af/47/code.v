module top_module(
  input clk,
  input reset,
  input up_down,
  output reg [2:0] q,
  output reg carry_out
);always @(posedge clk) begin
    if(reset) begin
      q <= 3'b0;
      carry_out <= 1'b0;
    end
    else if(up_down) begin
      if(q == 3'b111) begin
        q <= 3'b000;
        carry_out <= 1'b1;
      end
      else begin
        q <= q + 1;
        carry_out <= 1'b0;
      end
    end
    else begin
      if(q == 3'b000) begin
        q <= 3'b111;
        carry_out <= 1'b1;
      end
      else begin
        q <= q - 1;
        carry_out <= 1'b0;
      end
    end
  end

endmodule