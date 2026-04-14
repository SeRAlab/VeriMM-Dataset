module top_module( s0, s1, s2, s3, d0, d1, d2, d3 );parameter INPUT_WIDTH = 16;

input  [INPUT_WIDTH-1:0] s0, s1, s2, s3;
output [INPUT_WIDTH-1:0] d0, d1, d2, d3;


wire [INPUT_WIDTH-1:0] s01, s23, d01, d23;
wire [INPUT_WIDTH-1:0] n_s1_plus1; 
wire [INPUT_WIDTH-1:0] n_s3_plus1;

assign n_s1_plus1 = ~s1 + 1'b1;
assign n_s3_plus1 = ~s3 + 1'b1;

assign s01 = s0 + s1;
assign s23 = s2 + s3;
assign d01 = s0 + n_s1_plus1;
assign d23 = s2 + n_s3_plus1;

wire [INPUT_WIDTH-1:0] n_s23_plus1; 
wire [INPUT_WIDTH-1:0] n_d23_plus1;

assign n_s23_plus1 = ~s23 + 1'b1;
assign n_d23_plus1 = ~d23 + 1'b1;

assign d0 = s01 + s23;
assign d1 = s01 + n_s23_plus1;
assign d2 = d01 + n_d23_plus1;
assign d3 = d01 + d23;endmodule