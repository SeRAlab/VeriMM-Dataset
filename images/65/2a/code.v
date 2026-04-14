module top_module(data_in_0, data_in_1, data_in_2, data_in_3, sel_0, sel_1, data_out);// width of each input
   parameter width = 8;
   
   // data inputs
   input [0:width-1] data_in_0;
   input [0:width-1] data_in_1;
   input [0:width-1] data_in_2;
   input [0:width-1] data_in_3;
   
   // select inputs
   input [0:2-1] sel_0;
   input [0:2-1] sel_1;
   
   // data output
   output [0:width-1] data_out;
   
   // wire declarations
   wire [0:width-1] data_sel_0_0;
   wire [0:width-1] data_sel_0_1;
   wire [0:width-1] data_sel_1_0;
   wire [0:width-1] data_sel_1_1;
   wire [0:width-1] data_out_sel_0;
   wire [0:width-1] data_out_sel_1;
   
   // select input decoding
   assign data_sel_0_0 = (sel_0 == 2'b00) ? data_in_0 : data_in_1;
   assign data_sel_0_1 = (sel_0 == 2'b00) ? data_in_2 : data_in_3;
   assign data_sel_1_0 = (sel_1 == 2'b00) ? data_sel_0_0 : data_sel_0_1;
   assign data_sel_1_1 = (sel_1 == 2'b01) ? data_sel_0_0 : data_sel_0_1;
   
   // output selection
   assign data_out_sel_0 = (sel_1 == 2'b10) ? data_sel_1_0 : data_sel_1_1;
   assign data_out = (sel_1 == 2'b11) ? data_sel_1_0 : data_out_sel_0;
   
endmodule