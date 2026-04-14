module top_module(ins_o,ins_i,icm_i,clk_i);output ins_o;
input ins_i;
input [2:0] icm_i;
input clk_i;

reg ins_o;

reg prev_ins_i_reg;
reg ins_i_reg;
reg next_ins_o;



always @(icm_i or prev_ins_i_reg or ins_i_reg )
   begin

   if ((prev_ins_i_reg !=ins_i_reg )&&((icm_i =='h1)||
((icm_i =='h2||icm_i =='h6||icm_i =='h7)&&!ins_i_reg )||
((icm_i >='h3&&icm_i <1+'h7)&&!ins_i_reg )))
      begin

      next_ins_o  =(1);

      end
   else 
      begin

      next_ins_o  =(0);

      end


   end

always @(posedge clk_i )
   begin

   prev_ins_i_reg  <=(ins_i_reg );
   ins_i_reg  <=(ins_i );
   ins_o  <=(next_ins_o );

   end

endmodule