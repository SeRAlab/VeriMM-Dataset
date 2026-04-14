module top_module(ife_wb,op_wb,Ri_wbi,write_wb,Ri_wbo,reg_update,reg_new,pc_update,pc_new);input       ife_wb;
input [5:0] op_wb;
input [4:0] Ri_wbi;
input [31:0]write_wb;
output[4:0] Ri_wbo;
output      reg_update;
output[31:0]reg_new;
output      pc_update;
output[31:0]pc_new;

wire [4:0]  Ri_wbo;
wire        reg_update;
wire [31:0] reg_new;
wire        pc_update;
wire [31:0] pc_new;
 
assign Ri_wbo     =   Ri_wbi;
assign reg_update =  (op_wb[5:4]==2'b00  || op_wb==6'b010001) ? 1:0;
assign reg_new    =  (op_wb[5:4]==2'b00  || op_wb==6'b010001) ? write_wb:0;
assign pc_update  =  ((op_wb==6'b10_0000 && ife_wb) || op_wb==6'b10_0001) ? 1:0;
assign pc_new     =  ((op_wb==6'b10_0000 && ife_wb) || op_wb==6'b10_0001) ? write_wb:0;

endmodule