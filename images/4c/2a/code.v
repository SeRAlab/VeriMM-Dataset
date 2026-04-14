module top_module(
  input clk,
  input reset,
  output reg [2:0] count
);parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;

  reg [1:0] state;
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= A;
      count <= A;
    end else begin
      case (state)
        A: begin
          state <= B;
          count <= B;
        end
        B: begin
          state <= C;
          count <= C;
        end
        C: begin
          state <= A;
          count <= A;
        end
      endcase
    end
  end
endmodule