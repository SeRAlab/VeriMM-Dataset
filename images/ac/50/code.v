module top_module(
  input clk,
  input rst,
  input [1:0] coin,
  input dispense,
  output reg product,
  output reg [1:0] change
);reg [5:0] total_amount;

  always @(posedge clk) begin
    if (rst == 1) begin
      total_amount <= 0;
      product <= 0;
      change <= 0;
    end else begin
      if (dispense == 1) begin
        total_amount <= total_amount + {1'b0, coin};
        if (total_amount >= 50) begin
          product <= 1;
          case (total_amount - 50)
            0: change <= 0;
            1: change <= 1;
            5: change <= 2;
            15: change <= 3;
          endcase
          total_amount <= total_amount - 50;
        end
      end
    end
  end

endmodule