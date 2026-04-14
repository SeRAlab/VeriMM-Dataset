module top_module(
  input async_in,
  input clk_sync,
  input rst_sync,
  output sync_out
);reg [2:0] sync_reg; // chain of flip-flops to synchronize the signal
  reg sync_out_reg; // output of the synchronizer

  always @(posedge clk_sync or posedge rst_sync) begin
    if (rst_sync) begin
      sync_reg <= 3'b0; // reset the flip-flop chain
      sync_out_reg <= 1'b0; // reset the output
    end
    else begin
      sync_reg <= {sync_reg[1:0], async_in}; // sample the asynchronous signal
      sync_out_reg <= sync_reg[2]; // output the synchronized signal
    end
  end

  assign sync_out = sync_out_reg;

endmodule