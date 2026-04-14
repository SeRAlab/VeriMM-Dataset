module top_module(a,b,sum,cout);input a,b;
  output sum,cout;
  reg sum, cout;
  
  always @(a,b) begin
    #5 sum = a^b;
    #5 cout = a & b;
  end
endmodule