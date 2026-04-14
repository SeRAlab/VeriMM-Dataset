module top_module(in);input [1:0] in; 
  reg a, b; 
  reg [1:0] c; 

  always @* begin
    a = in[0]; 
    c[0] = in[0]; 
    if (a < 1'b1) begin
      b = in[1]; 
      c[1] = in[1];
    end
  end 

  always @* begin
    a = 0; 
    c[in] = 0; 
    if (a < 1'b1) begin
      b = 1'b1; 
      c[in] = 2'b10; 
    end
  end 

endmodule