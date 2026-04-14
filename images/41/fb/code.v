module top_module(
  input clk,
  input data,
  output reg q,
  output reg q_bar
);reg [1:0] state;
reg q_int, q_bar_int;

always @ (posedge clk)
begin
  case (state)
    2'b00: begin
      q_int <= data;
      q_bar_int <= ~data;
      state <= 2'b01;
    end
    2'b10: begin
      q_int <= data;
      q_bar_int <= ~data;
      state <= 2'b11;
    end
    default: state <= 2'b00;
  endcase
end

always @ (negedge clk)
begin
  case (state)
    2'b01: begin
      q <= q_int;
      q_bar <= q_bar_int;
      state <= 2'b10;
    end
    2'b11: begin
      q <= q_int;
      q_bar <= q_bar_int;
      state <= 2'b00;
    end
    default: state <= 2'b00;
  endcase
end

endmodule