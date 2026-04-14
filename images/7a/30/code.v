module top_module(
  input [18:0] AddressBus,
  input [18:0] TagData,

  output reg Hit_H
);always@(*)begin
  if(AddressBus == TagData) Hit_H=1;
  else Hit_H = 0;
end

endmodule