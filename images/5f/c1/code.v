module top_module(input clk, input d, output q);reg [2:0] reg_data;
  reg q_out;
  
  always @(posedge clk) begin
    reg_data <= {reg_data[1:0], d};
    q_out <= reg_data[2];
  end
  
  assign q = q_out;
endmodule