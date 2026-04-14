module shift_register 
(
  input rst_n,
  input clk,
  input shift_enable,

  output reg [7:0] out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
    begin
      out <= 8'b00000000;
    end 
    else if (shift_enable) 
    begin
      out <= out << 1;
    end 
    else 
    begin
      out <= out; // Pause the shift when shift_enable is invalid
    end
  end

endmodule