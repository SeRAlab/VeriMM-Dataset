module top_module(
  input clk,
  input reset,
  output reg [3:0] counter_out,
  output reg mux_out
);reg [3:0] counter;
  reg select;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 0;
      mux_out <= 1'b0;
      select <= 1'b0;
    end else begin
      counter <= counter + 1;
      if (counter == 5) begin
        select <= ~select;
      end
      if (counter == 10) begin
        counter <= 0;
      end
    end
  end

  always @(*) begin
    mux_out = select ? 1'b1 : 1'b0; // Changed to combinational logic
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter_out <= 4'b0000;
    end else begin
      counter_out <= counter;
    end
  end

endmodule