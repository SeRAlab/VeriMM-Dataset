module priority_encoder(
    input [3:0] in,

    output [1:0] out,
    output valid
);

assign valid = |in;

always @(*)
begin
  if (in[3])
    out = 2'b11;
  else if (in[2])
    out = 2'b10;
  else if (in[1])
    out = 2'b01;
  else if (in[0])
    out = 2'b00;
  else
    out = 2'b00;
end

endmodule