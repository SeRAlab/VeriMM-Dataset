module top_module(
  input clk,
  input enable_update,
  input enable,
  input [7:0]dbA,
  input [7:0]dbB,
  input [7:0]dbC,
  input [7:0]dbD,
  output reg [7:0]db,
  output wire clr_n,
  output wire pd_n,
  output reg cs_n,
  output reg wr_n,
  output reg [1:0]A,
  output reg ldac_n
);reg [7:0] clk_div;
reg clk_int;
always @(posedge clk) begin
  clk_div <= clk_div + 1;
  clk_int <= (clk_div == 8'HFF);
  
  
  
  
end

assign clr_n = enable;
assign pd_n = 1;

reg [7:0]dbA_prev;
reg [7:0]dbB_prev;
reg [7:0]dbC_prev;
reg [7:0]dbD_prev;
reg update_trigger;

always @(posedge clk_int && enable_update) begin
  if ((dbA != dbA_prev) || (dbB != dbB_prev) || (dbC != dbC_prev) || (dbD != dbD_prev))
    update_trigger <= 1;
  else
    update_trigger <= 0;
  dbA_prev <= dbA;
  dbB_prev <= dbB;
  dbC_prev <= dbC;
  dbD_prev <= dbD;
end


reg [3:0] cntr;
always @(posedge clk_int) begin
  if ((update_trigger == 1) || (cntr != 0)) begin
    cntr <= (cntr + 1) % 10;

    case (cntr)
      0 : begin
        A <= 2'b00;
        db <= dbA;
      end
      1 :
        wr_n <= 1;
      2 : begin
        A <= 2'b01;
        db <= dbB;
        wr_n <= 0;
      end
      3 :
        wr_n <= 1;
      4 : begin
        A <= 2'b10;
        db <= dbC;
        wr_n <= 0;
      end
      5 :
        wr_n <= 1;
      6 : begin
        A <= 2'b11;
        db <= dbD;
        wr_n <= 0;
      end
      7 :
        wr_n <= 1;
      8 :
        wr_n <= 0;
      9 :
        ldac_n <= 1;
      10 :
        ldac_n <= 0;
    endcase
  end
end

endmodule