module top_module(
  input [3:0] in,
  output reg [1:0] out  // Change to reg type to allow assignment in always block
);always @ (in) begin
    if (in[3] == 1) begin
      out = 2'b11;
    end else if (in[2] == 1) begin
      out = 2'b10;
    end else if (in[1] == 1) begin
      out = 2'b01;
    end else if (in[0] == 1) begin
      out = 2'b00;
    end else begin
      out = 2'b00; // Default case if no inputs are high
    end
  end
  
endmodule