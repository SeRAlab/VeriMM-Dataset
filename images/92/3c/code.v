module top_module( input wire [6:0] inst_i
  , input wire  signed [31:0] r1_i
  , output reg [31:0] r1_shift_o
  );wire [4:0] shift_imm;
  wire [2:0] shift_type;
  wire signed [31:0] r1_shift_tmp;

  assign shift_imm = inst_i[6:2];
  assign shift_type = inst_i[1:0];

  always @(*) begin
    if (shift_type == 0)  
      r1_shift_o = r1_i << shift_imm;
    else if (shift_type == 2'b01) 
      r1_shift_o = r1_i >> shift_imm;
    else if (shift_type == 2'b10) 
      r1_shift_o = r1_i >>> shift_imm;
  end
endmodule