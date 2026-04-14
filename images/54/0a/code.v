module reg_16bit(
    input clk,
    input rst,
    input load,
    input [15:0] d,

    output reg [15:0] q
);

always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    q <= 16'b0;
  end
  else if(load)
  begin
    q <= d;
  end
end

endmodule