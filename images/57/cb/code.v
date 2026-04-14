module top_module(
           CLK_IN,
           reset,
           clk_enable,
           enb,
           enb_1_1_1,
           enb_1_2000_0,
           enb_1_2000_1
          );input   CLK_IN;
  input   reset;
  input   clk_enable;
  output  enb;
  output  enb_1_1_1;
  output  enb_1_2000_0;
  output  enb_1_2000_1;


  reg [10:0] count2000;  
  wire phase_all;
  reg  phase_0;
  wire phase_0_tmp;
  reg  phase_1;
  wire phase_1_tmp;


  always @ ( posedge CLK_IN)
    begin: Counter2000
      if (reset == 1'b1) begin
        count2000 <= 11'b00000000001;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (count2000 == 11'b11111001111) begin
            count2000 <= 11'b00000000000;
          end
          else begin
            count2000 <= count2000 + 1;
          end
        end
      end
    end 

  assign  phase_all = clk_enable? 1 : 0;

  always @ ( posedge CLK_IN)
    begin: temp_process1
      if (reset == 1'b1) begin
        phase_0 <= 1'b0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          phase_0 <= phase_0_tmp;
        end
      end
    end 

  assign  phase_0_tmp = (count2000 == 11'b11111001111 && clk_enable == 1'b1)? 1 : 0;

  always @ ( posedge CLK_IN)
    begin: temp_process2
      if (reset == 1'b1) begin
        phase_1 <= 1'b1;
      end
      else begin
        if (clk_enable == 1'b1) begin
          phase_1 <= phase_1_tmp;
        end
      end
    end 

  assign  phase_1_tmp = (count2000 == 11'b00000000000 && clk_enable == 1'b1)? 1 : 0;

  assign enb =  phase_all & clk_enable;

  assign enb_1_1_1 =  phase_all & clk_enable;

  assign enb_1_2000_0 =  phase_0 & clk_enable;

  assign enb_1_2000_1 =  phase_1 & clk_enable;


endmodule