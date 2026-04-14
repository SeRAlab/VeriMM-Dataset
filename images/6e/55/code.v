module top_module(
  input [31:0] i,
  output reg [7:0] o0, o1, o2, o3, o4,
  output reg [2:0] len
);reg [6:0] c0, c1, c2, c3, c4;
reg [4:0] co;
reg [4:0] gl;


always @* begin
  
  {c4, c3, c2, c1, c0} = i;
  
  co[0] = (|c0);
  co[1] = (|c1);
  co[2] = (|c2);
  co[3] = (|c3);
  co[4] = (|c4);
  
  gl[0] = co[4] | co[3] | co[2] | co[1];
  gl[1] = co[4] | co[3] | co[2];
  gl[2] = co[4] | co[3];
  gl[3] = co[4];
  gl[4] = 1'b0;
  
  len[0] = gl[0] | gl[2] | gl[4];
  len[1] = gl[1] | gl[2];
  len[2] = gl[4] | gl[5];
  
  o0 = {gl[0], c0};
  o1 = {gl[1], c1};
  o2 = {gl[2], c2};
  o3 = {gl[3], c3};
  o4 = {gl[4], c4};
end

endmodule