module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);reg [1:0] state;

always @(posedge clk) begin
  if (reset) begin
    state <= 2'b00;
    match <= 1'b0;
  end
  else begin
    case (state)
      2'b00: begin
        if (data) begin
          state <= 2'b01;
        end
        else begin
          state <= 2'b00;
        end
      end
      2'b01: begin
        if (data) begin
          state <= 2'b10;
        end
        else begin
          state <= 2'b00;
        end
      end
      2'b10: begin
        if (data) begin
          state <= 2'b11;
          match <= ~match;
        end
        else begin
          state <= 2'b00;
        end
      end
      2'b11: begin
        if (data) begin
          state <= 2'b10;
        end
        else begin
          state <= 2'b00;
        end
      end
      default: begin
        state <= 2'b00;
      end
    endcase
  end
end

endmodule