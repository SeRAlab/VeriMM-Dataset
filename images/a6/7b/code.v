module top_module(in_data, out_data);input wire [11:0] in_data;
output wire [31:0] out_data;

wire [31:0] line1 = 7540 - (in_data * 364);
wire [31:0] line2 = 6637 - (in_data * 235);
wire [31:0] line3 = 5317 - (in_data * 147);
wire [31:0] line4 = 4006 - (in_data * 90);
wire [31:0] line5 = 2983 - (in_data * 57);
wire [31:0] line6 = 2008 - (in_data * 32);
wire [31:0] line7 = 1039 - (in_data * 13);
wire [31:0] line8 = 207 - (in_data * 2);

assign out_data = (in_data < 1024) ? line1 :
                  (in_data < 2048) ? line2 :
                  (in_data < 3072) ? line3 :
                  (in_data < 4096) ? line4 :
                  (in_data < 5120) ? line5 :
                  (in_data < 6656) ? line6 :
                  (in_data < 9472) ? line7 :
                                     line8;
									 
endmodule