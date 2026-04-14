module top_module(
  input reset,
  input sysclk,
  output reg selection,
  output reg [6:0] egg_timer
);parameter TOGGLE_VALUE = 100;

reg [31:0] count;

always @(posedge sysclk) begin
  if (reset) begin
    count <= 0;
    selection <= 1'b1;
    egg_timer <= 7'b0;
  end else begin
    count <= count + 1;
    if (count == TOGGLE_VALUE) begin
      selection <= ~selection;
      if (count == TOGGLE_VALUE) begin
        egg_timer <= 7'b1111111;
      end else begin
        egg_timer <= 7'b0;
      end
    end else begin
      egg_timer <= 7'b0;
    end
  end
end

endmodule