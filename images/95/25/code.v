module top_module(clk, rst, countEn, zeroM, out);parameter DW = 8;

input clk, rst, countEn, zeroM;
output reg [DW-1:0] out;
always @ ( posedge clk, posedge rst ) begin
  if(rst) begin
    out <= 0;
  end
  else begin
    if(zeroM) begin
      out <= 0;
    end
    else begin
      if(countEn)begin
        out <= out + 1;
      end
    end
  end
end

endmodule