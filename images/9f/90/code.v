module top_module(input wire op1sel, input wire [31:0] rs1, input wire [19:0] upperimm, output reg [31:0] out);always @ ( op1sel, rs1, upperimm ) begin
  
  if (op1sel == 0 ) begin
    out = rs1;
  end
  if (op1sel == 1) begin
    out = upperimm;
  end

end

endmodule