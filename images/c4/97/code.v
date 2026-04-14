module sync_counter_4bit (
  input clk,
  input reset,
  input parallel_load,
  input [3:0] load_input,
  output reg [3:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0;
    end else if (parallel_load) begin
      count <= load_input;
    end else begin
      count <= count + 1;
    end
  end

endmodule
