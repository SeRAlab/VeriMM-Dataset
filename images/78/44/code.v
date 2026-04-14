module top_module(clk, rst, load, D, Q);input clk, rst, load;
  input [0:0] D;
  output reg [0:0] Q; // Changed output Q to be reg type
  wire n3, n4, n5, n6;

  // D flip-flop with reset and load enable using built-in DFF
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q <= 1'b0;
    end else if (load) begin
      Q <= D;
    end else begin
      if (n5) begin
        Q <= Q + 1'b1;
      end else if (n6) begin
        Q <= Q - 1'b1;
      end
    end
  end

  // inverter
  assign n4 = ~rst;

  // OR gate for addition
  assign n5 = Q[0] | load;

  // inverter for subtraction
  assign n6 = ~load;

  // edge case for using D flip-flop directly is removed since it's not needed

endmodule