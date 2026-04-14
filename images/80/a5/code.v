module top_module(input [3:0] in, input load, input clear, output [3:0] out);reg [3:0] reg_out;
  
  always @(*) begin
    if (clear) begin
      reg_out = 0;
    end else if (load) begin
      reg_out = in;
    end
  end
  
  assign out = reg_out;
endmodule