module top_module(rst, rw, X, Y, Z, Pset, Pid, Pz, Px, Py, Pval);input rst;
  input rw; 
  input [1:0] X;
  input [1:0] Y;
  input [1:0] Z;
  input [1:0] Pid;
  input Pz;
  input Pset;
  output Px;
  output Py;
  output Pval;
  
  reg pregs [3:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      
      pregs[0] <= 1;
      pregs[1] <= 1;
      pregs[2] <= 0;
      pregs[3] <= 0;
    end else begin
      if(rw == 1)
        pregs[Z] <= Pz;
    end
  end
  
  assign Px = pregs[X];
  assign Py = pregs[Y];
  assign Pval = (Pset == 1) ? pregs[Pid] : 1'b1;endmodule