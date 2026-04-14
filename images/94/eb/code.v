module top_module(
  input         clock, reset, 
  output [3:0]  count
);reg [3:0] counter;

  always @ (posedge clock) begin
    if (reset) begin
      counter <= 4'b0;
    end else begin
      counter <= counter + 1;
    end
  end

  assign count = counter;

endmodule