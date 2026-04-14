module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  output reg parity_out
);reg [7:0] pipeline_reg [0:2]; // Array declaration correction
  reg [1:0] pipeline_ptr;

  always @ (posedge clk) begin
    if (reset) begin
      pipeline_reg[0] <= 0; // Initialize each register individually
      pipeline_reg[1] <= 0;
      pipeline_reg[2] <= 0;
      pipeline_ptr <= 0;
      parity_out <= 1;
    end
    else begin
      pipeline_reg[pipeline_ptr] <= data_in;
      pipeline_ptr <= (pipeline_ptr == 2) ? 0 : pipeline_ptr + 1;
      parity_out <= ~(pipeline_reg[0] ^ pipeline_reg[1] ^ pipeline_reg[2]);
    end
  end
  
endmodule