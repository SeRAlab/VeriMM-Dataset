module top_module(
  input clk,
  input reset, // Synchronous active-high reset
  output [4:0] sum // Binary sum output
);reg [2:0] binary_counter;
  reg [1:0] gray_counter;

  // Binary Counter
  always @(posedge clk) begin
    if (reset) begin
      binary_counter <= 3'b000;
    end else begin
      binary_counter <= binary_counter + 1;
    end
  end

  // Gray Code Counter
  always @(posedge clk) begin
    if (reset) begin
      gray_counter <= 2'b00;
    end else begin
      case (gray_counter)
        2'b00: gray_counter <= 2'b01;
        2'b01: gray_counter <= 2'b11;
        2'b11: gray_counter <= 2'b10;
        2'b10: gray_counter <= 2'b00;
      endcase
    end
  end

  // Sum Module
  assign sum = binary_counter + gray_counter;

endmodule