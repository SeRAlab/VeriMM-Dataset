module top_module(in_data, out_data);input wire [6:0] in_data;
output wire [31:0] out_data;


wire [31:0] line1 = 7540 - ({in_data,8'b0}+{in_data,6'b0}+{in_data,5'b0}+{in_data,3'b0}+{in_data,2'b0});


wire [31:0] line2 = 6637 - ({in_data,8'b0}-{in_data,5'b0}+{in_data,3'b0}+{in_data,1'b0});


wire [31:0] line3 = 5317 - ({in_data,7'b0}+{in_data,4'b0}+{in_data,1'b0}+in_data);


wire [31:0] line4 = 4006 - ({in_data,6'b0}+{in_data,4'b0}+{in_data,3'b0}+{in_data,2'b0});


wire [31:0] line5 = 2983 - ({in_data,6'b0}-{in_data,3'b0}+in_data);


wire [31:0] line6 = 2008 - ({in_data,5'b0});


wire [31:0] line7 = 1039 - ({in_data,3'b0}+{in_data,2'b0}+in_data);



wire [31:0] line8 = (16'hCECC - ( {in_data,8'b0} + {in_data,7'b0} + {in_data,4'b0} + {in_data,3'b0} + in_data ) ) >> 8;



assign out_data = (in_data <  8) ?  line1 :
                  (in_data < 16) ?  line2 :
                  (in_data < 24) ?  line3 :
                  (in_data < 32) ?  line4 :
                  (in_data < 40) ?  line5 :
                  (in_data < 52) ?  line6 :
                  (in_data < 74) ?  line7 :
                                    line8;
									 
endmodule