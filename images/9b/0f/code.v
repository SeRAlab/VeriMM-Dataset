module top_module(rst, rw, X, Y, Z, Rz, Rx, Ry);input rst;
  input rw; 
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Rz;
  output [31:0] Rx;
  output [31:0] Ry;
  
  reg [31:0] gregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        gregs[i] <= i;
      end
    end else begin 
      if(rw == 1)
        gregs[Z] <= Rz;
    end
  end
  
  assign Rx = gregs[X];
  assign Ry = gregs[Y];endmodule