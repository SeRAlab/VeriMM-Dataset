module top_module(
   
   z,
   
   a, b, rstn
   );input  a;
  input  b;
  input  rstn;
  output z;

  
  
  reg                   z;
  

  always @* begin
    if(rstn == 1'b0) begin
      z <= 0;
    end
    else begin
      if(a == b)
        z <= #1 a;
    end

  end



endmodule