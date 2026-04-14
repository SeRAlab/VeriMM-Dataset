module top_module(
  input empty,
  input free2,
  input free3,
  input [1:0] tm_count,
  output reg [4:0] fifocount_inc
);always @(*) begin
    if (empty) begin
      fifocount_inc = tm_count[1:0];
    end else if (free3 && (tm_count == 2'b11)) begin
      fifocount_inc = 2;
    end else if (free2 && (tm_count >= 2)) begin
      fifocount_inc = 1;
    end else if (tm_count >= 1) begin
      fifocount_inc = 0;
    end else begin
      fifocount_inc = 5'b11111;
    end
  end

endmodule