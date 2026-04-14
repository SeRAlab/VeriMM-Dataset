module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input [1:0] shift_direction,
  input load,
  output [7:0] data_out
);reg [7:0] shift_reg;
  
  initial begin
    shift_reg = 8'h34;
  end
  
  always @(negedge clk or posedge reset) begin
    if (reset) begin
      shift_reg <= 8'h00;
    end
    else begin
      if (load) begin
        shift_reg <= data_in;
      end
      else begin
        if (shift_direction == 2'b00) begin // shift right
          shift_reg <= {shift_reg[0], shift_reg[7:1]};
        end
        else if (shift_direction == 2'b01) begin // shift left
          shift_reg <= {shift_reg[6:0], shift_reg[7]};
        end
      end
    end
  end
  
  assign data_out = shift_reg;
  
endmodule