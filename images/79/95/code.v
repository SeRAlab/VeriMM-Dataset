module top_module(
  input clk,
  input rst,
  input enable,

  output reg signed [31:0] out_data
);reg [4:0] data;
reg [4:0] data_next;

always @* begin
  data_next[4] = data[4]^data[1];
  data_next[3] = data[3]^data[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk)
  if(rst)
    data <= 5'h1f;
  else begin
  if(enable==1'b1) out_data<=data_next*4;
  
  else if(enable==1'b0)out_data<='b0;
    data <= data_next;

end
endmodule