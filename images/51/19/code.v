module top_module(
   input         clock, reset, load,
   input [15:0]  loadValue,
   output [15:0] count,
   output        flag);reg [15:0]    countReg = 16'b0;
   wire          flagWire;

   assign flag = flagWire;
   assign count = countReg;

   always @ (posedge clock) begin 
      if (reset)
         countReg <= 16'b0;
      else if (load)
         countReg <= loadValue;
      else if (countReg == {16{1'b1}})
         countReg <= 16'b0;
      else
         countReg <= countReg + 1;
   end

   assign flagWire = (countReg == {16{1'b1}});

endmodule