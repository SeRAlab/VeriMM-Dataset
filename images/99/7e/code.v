module top_module(
  input clk,
  input rst,
  input en,
  output reg [35:0] tr_data
);always @(posedge clk) begin
    if (rst) begin
      tr_data <= 0;
    end else if (en) begin
      if (tr_data[0] == 0) begin
        tr_data <= tr_data + 1;
      end else begin
        tr_data <= tr_data * 3 + 1;
      end
      if (tr_data >= 2**36) begin
        tr_data <= 0;
      end
    end
  end

endmodule