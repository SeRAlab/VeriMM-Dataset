module top_module(
  input clk,
  input enable_i,
  input reset_i,
  input quadA_i,
  input quadB_i,
  output reg direction_o,
  output reg count_pulse_o,
  output reg error_o
);reg quadA, quadB, quadA_old, quadB_old;
reg [1:0] state;
reg [7:0] count;

parameter IDLE = 2'b00, FORWARD = 2'b01, REVERSE = 2'b10;

always @(posedge clk) begin
  if (reset_i) begin
    state <= IDLE;
    count <= 8'b0;
    direction_o <= 1'b0;
    count_pulse_o <= 8'b0;
    error_o <= 1'b0;
  end else if (enable_i) begin
    quadA <= quadA_i;
    quadB <= quadB_i;
    quadA_old <= quadA;
    quadB_old <= quadB;
    case (state)
      IDLE: begin
        if (quadA == 1'b1 && quadB == 1'b0) begin
          state <= FORWARD;
        end else if (quadA == 1'b0 && quadB == 1'b1) begin
          state <= REVERSE;
        end else if (quadA != quadA_old || quadB != quadB_old) begin
          error_o <= 1'b1;
        end
      end
      FORWARD: begin
        if (quadA == 1'b0 && quadB == 1'b0) begin
          count <= count + 8'b1;
          count_pulse_o <= count;
          direction_o <= 1'b0;
          state <= IDLE;
        end else if (quadA == 1'b1 && quadB == 1'b1) begin
          count <= count - 8'b1;
          count_pulse_o <= count;
          direction_o <= 1'b1;
          state <= IDLE;
        end else if (quadA != quadA_old || quadB != quadB_old) begin
          error_o <= 1'b1;
        end
      end
      REVERSE: begin
        if (quadA == 1'b1 && quadB == 1'b1) begin
          count <= count + 8'b1;
          count_pulse_o <= count;
          direction_o <= 1'b1;
          state <= IDLE;
        end else if (quadA == 1'b0 && quadB == 1'b0) begin
          count <= count - 8'b1;
          count_pulse_o <= count;
          direction_o <= 1'b0;
          state <= IDLE;
        end else if (quadA != quadA_old || quadB != quadB_old) begin
          error_o <= 1'b1;
        end
      end
    endcase
  end
end

endmodule