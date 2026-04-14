module top_module(
  input clk,
  output reg count
);reg [4:0] counter; // 5-bit counter to count up to 30

  always @(posedge clk) begin
    if (counter == 29) begin
      count <= 1;
      counter <= 0; // Reset the counter after reaching 30
    end else begin
      count <= 0; // Only pulse high for one clock cycle
      counter <= counter + 1; // Increment the counter
    end
  end
endmodule