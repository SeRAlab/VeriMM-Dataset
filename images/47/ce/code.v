module top_module(
  input clk,
  input reset,
  input load,
  input [2:0] load_data,
  input [1:0] and_input,
  output reg out
);reg [2:0] shift_reg;
  
  always @ (posedge clk) begin
    if (reset) begin
      shift_reg <= 3'b0;
    end
    else begin
      if (load) begin
        shift_reg <= load_data;
      end
      else begin
        shift_reg <= {1'b0, shift_reg[2:1]};
      end
    end
  end
  
  assign out = and_input[0] & and_input[1] & shift_reg[0];
  
endmodule