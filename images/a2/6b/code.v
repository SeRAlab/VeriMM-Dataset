module top_module(
  input clock,
  input reset,
  input PCEn,
  input [7:0] in, 
  output [7:0] out
);reg [7:0] Data;
  
  always@(posedge clock, posedge reset) begin
    
    if(reset)
      Data <= 8'b0;
    else if(PCEn)
      Data <= in;
  end
  assign out = Data;
endmodule