module top_module(input [3:0] D, output reg [3:0] Q, input load, clock, shift_left, shift_right, reset);always @(posedge clock or negedge reset) begin
    if (!reset)
      Q <= 4'b0000;
    else if (load)
      Q <= D;
    else if (shift_left)
      Q <= {Q[2:0], 1'b0};
    else if (shift_right)
      Q <= {1'b0, Q[3:1]};
  end
endmodule