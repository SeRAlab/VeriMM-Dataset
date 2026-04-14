module top_module(temp_ip, temp_op, temp_clk, temp_en);input wire [15:0] temp_ip;
 output reg [15:0] temp_op;
 input wire temp_clk, temp_en;
 
 always@ (posedge temp_clk)
 begin
 if(temp_en) begin
  temp_op = temp_ip;
  end
 end
endmodule