module top_module(input CLK, Reset, 
                   Set,  D, output reg Q);always @(posedge CLK) begin
    if (Reset == 0 && Set == 0)
      Q = D; 
  end
  
  always @(Reset) begin
    Q = 0;
  end
  
  always @(Set) begin
    Q = 1;
  end
  
endmodule