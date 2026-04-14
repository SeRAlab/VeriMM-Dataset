module top_module(
  input clk,
  input reset,
  output reg [2:0] state,
  output reg out
);always @(posedge clk) begin
    if (reset) begin
      state <= 3'b000;
      out <= 1'b0;
    end
    else begin
      case (state)
        3'b000: state <= 3'b001;
        3'b001: state <= 3'b010;
        3'b010: state <= 3'b011;
        3'b011: state <= 3'b100;
        3'b100: state <= 3'b101;
        3'b101: state <= 3'b110;
        3'b110: begin
          state <= 3'b000;
          out <= 1'b1;
        end
      endcase
    end
  end

endmodule