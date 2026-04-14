module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg [1:0] pipeline_reg; // Pipeline register to store previous and current values of 'a'

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      pipeline_reg <= 2'b0; // Reset pipeline register
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      pipeline_reg <= {pipeline_reg[0], a}; // Shift in current value of 'a' into pipeline register
      if (pipeline_reg == 2'b01) begin // Detect rising edge
        rise <= 1'b1;
        down <= 1'b0;
      end
      else if (pipeline_reg == 2'b10) begin // Detect falling edge
        rise <= 1'b0;
        down <= 1'b1;
      end
      else begin
        rise <= 1'b0;
        down <= 1'b0;
      end
    end
  end

endmodule