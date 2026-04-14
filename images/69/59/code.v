module top_module(
  input [3:0] inputs,
  output reg [1:0] encoded_output
);always @ (inputs) begin
    if (inputs[3] == 1) begin
      encoded_output = 2'b11;
    end else if (inputs[2] == 1) begin
      encoded_output = 2'b10;
    end else if (inputs[1] == 1) begin
      encoded_output = 2'b01;
    end else if (inputs[0] == 1) begin
      encoded_output = 2'b00;
    end
  end
  
endmodule