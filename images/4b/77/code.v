module top_module(
  output [3:0] q3,
  input [3:0] d,
  input clk
);reg [3:0] q1, q2, r_q3;
  reg [31:0] counter = 0;
  reg CE;
  
  always @ (posedge clk) 
    begin 
      if (counter < 125000000)
        counter <= counter +1;
      else counter <=0;
    end 
  
  always @ (posedge clk)
     begin 
       if (counter ==120000000)
         CE <=1;
       else CE <=0;
     end 
  
  always @ (posedge clk)
    begin
      q1 <= d;
      q2 <= q1;
      r_q3 <= q2;
    end
  
  assign q3 = r_q3;
  
endmodule