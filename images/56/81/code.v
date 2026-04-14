module top_module(
  input i_clk,
  input [15:0] i_addr,
  output reg [13:0] o_addr,
  output reg o_neg
);always @ (posedge i_clk)
  begin
    case ({i_addr[15], i_addr[14]})
      2'b00 :
        begin
          o_addr <= i_addr[13:0];
          o_neg <= 0;
        end
      2'b01 :
        begin
          o_addr <= ~i_addr[13:0];
          o_neg <= 0;
        end
      2'b10 :
        begin
          o_addr <= i_addr[13:0];
          o_neg <= 1;
        end
      2'b11 :
        begin
          o_addr <= ~i_addr[13:0];
          o_neg <= 1;
        end
    endcase
  end

endmodule