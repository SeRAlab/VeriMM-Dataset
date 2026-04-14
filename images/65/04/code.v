module top_module(
           CLK_IN,
           reset,
           enb,
           In1,
           Out1
          );input   CLK_IN;
  input   reset;
  input   enb;
  input   In1;
  output  Out1;


  wire Constant1_out1;
  wire Switch_out1;
  reg  Delay_out1;


  
  assign Constant1_out1 = 1'b1;



  
  always @(posedge CLK_IN)
    begin : Delay_process
      if (reset == 1'b1) begin
        Delay_out1 <= 1'b0;
      end
      else if (enb) begin
        Delay_out1 <= Switch_out1;
      end
    end



  
  assign Switch_out1 = (Delay_out1 == 1'b0 ? In1 :
              Constant1_out1);



  assign Out1 = Switch_out1;

endmodule