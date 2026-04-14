module top_module(
   
   z,
   
   a, p, n, rstn
   );input  a;
  input  p;
  input  n;
  input  rstn;
  output z;

  
  
  reg                   z;
  

  always @* begin
    if(rstn == 1'b0) begin
      z <= 0;
    end
    else begin
      if((a==1'b1) & (p==1'b1)) begin
        z <= #1 1'b1;
      end
      else if((a==1'b0) & (n==1'b0)) begin
         z <= #1 1'b0;
      end
    end

  end



endmodule