module top_module(
  input clk, rst, clk_ena, load,
  input [5:0] dfload,
  output carry
);reg [5:0] count;
  reg carry_tmp;

  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
      carry_tmp <= 0;
    end
    else if (clk_ena) begin
      if (load) begin
        count <= dfload;
        carry_tmp <= 0;
      end
      else begin
        if (count == 0) begin
          count <= 0;
          carry_tmp <= 1;
        end
        else begin
          count <= count - 1;
          carry_tmp <= 0;
        end
      end
    end
  end

  assign carry = carry_tmp;

endmodule