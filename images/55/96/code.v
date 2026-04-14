module top_module(
  input [15:0] EU_immediate, 
  input ExtSign,  
  output reg [31:0] extended  
  );always@(*)
  begin
    if(ExtSign)
      begin
        extended[15:0] = EU_immediate;
        extended[31:16] = EU_immediate[15] ? 16'hffff : 16'h0000;
      end
  end
endmodule