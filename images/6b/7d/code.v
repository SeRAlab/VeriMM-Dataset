module top_module(
  input clk,        // Added clock input
  input sw,
  output reg deb    // Changed output to reg
);parameter clk_period = 10; // clock period in ns.

reg [1:0] state;
reg debounced;
reg [31:0] debounce_timer;

always @(posedge clk) begin
  case (state)
    2'b00: begin // waiting for switch to stabilize
      debounce_timer <= debounce_timer + 1;
      if (sw != debounced) begin
        debounce_timer <= 0;
        state <= 2'b01;
      end
    end
    2'b01: begin // waiting for debounce time
      debounce_timer <= debounce_timer + 1;
      if (debounce_timer >= (10 * clk_period)) begin
        debounced <= sw;
        state <= 2'b10;
      end
    end
    2'b10: begin // output debounced signal
      deb <= debounced;  // deb can be assigned here since it's a reg
      if (sw != debounced) begin
        debounce_timer <= 0;
        state <= 2'b01;
      end
    end
  endcase
end

endmodule