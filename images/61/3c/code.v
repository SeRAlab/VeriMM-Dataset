module top_module(rst, rw, X, Y, Z, Fz, Fx, Fy);input rst;
  input rw; 
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Fz;
  output [31:0] Fx;
  output [31:0] Fy;
  
  reg [31:0] fregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        fregs[i] <= 0;
      end
      
      fregs[1] <= 32'h4091999A;
      fregs[3] <= 32'h40800000;
      fregs[5] <= 32'h40200000;
    end else begin 
      if(rw == 1)
        fregs[Z] <= Fz;
    end
  end
  
  assign Fx = fregs[X];
  assign Fy = fregs[Y];endmodule