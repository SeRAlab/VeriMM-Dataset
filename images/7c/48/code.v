module top_module(input[9:0] x1,
                input[8:0] y1,
                input[9:0] x2,
                input[8:0] y2,
                input[9:0] x3,
                input[8:0] y3,
                input[9:0] x4,
                input[8:0] y4,
                output wire[6:0] percent_kept);wire signed[10:0] sx1, sx2, sx3, sx4;
wire signed[9:0] sy1, sy2, sy3, sy4;
wire signed[10:0] d_x1_x3, d_x2_x4;
wire signed[9:0] d_y1_y3, d_y2_y4;
wire signed[20:0] prod0, prod1;
wire signed[20:0] prod;
wire signed[20:0] abs_prod;
wire[20:0] unsigned_prod;
wire[13:0] shift_prod_7;
wire[11:0] shift_prod_9;
wire[9:0] shift_prod_11;
wire[14:0] sum_shift_prod;


assign sx1 = {1'b0, x1};
assign sx2 = {1'b0, x2};
assign sx3 = {1'b0, x3};
assign sx4 = {1'b0, x4};
assign sy1 = {1'b0, y1};
assign sy2 = {1'b0, y2};
assign sy3 = {1'b0, y3};
assign sy4 = {1'b0, y4};


assign d_x1_x3 = sx1 - sx3;
assign d_x2_x4 = sx2 - sx4;
assign d_y1_y3 = sy1 - sy3;
assign d_y2_y4 = sy2 - sy4;


assign prod0 = d_x1_x3 * d_y2_y4;
assign prod1 = d_y1_y3 * d_x2_x4;


assign prod = prod0 - prod1; 


assign abs_prod = (prod < 0) ? -prod : prod;
assign unsigned_prod = abs_prod;










assign shift_prod_7 = unsigned_prod >> 7;
assign shift_prod_9 = unsigned_prod >> 9;
assign shift_prod_11 = unsigned_prod >> 11;
assign sum_shift_prod = shift_prod_7 + shift_prod_9 + shift_prod_11;
assign percent_kept = sum_shift_prod >> 6;

endmodule