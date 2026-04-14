module top_module(instruction,signExtended);input [31:0]instruction;
output reg [63:0]signExtended;
wire ins = (instruction[31] == 1'b0) ? 52'b0: 52'b1;
always @(*)
  begin
   case(instruction[5:0])
   7'b0000011: signExtended = {ins,instruction[31:20]};
   7'b0100011: signExtended = {ins,instruction[11:5],instruction[4:0]};
   7'b1100011: signExtended = {ins,instruction[12],instruction[10:5],instruction[4:1],instruction[11]};
   endcase
  end

endmodule