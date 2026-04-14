module top_module(
  input clock,
  input reset,
  input [15:0] In,
  input InEnable,
  output [15:0] Out
);reg [15:0]myRegIFToID;
  always@(posedge clock) begin

    if(reset)
      myRegIFToID = 0;
    else if(InEnable) myRegIFToID = In; 
  end
  
  assign Out = myRegIFToID;
  endmodule