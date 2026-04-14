module top_module(
  input clk,
  input rst,
  input enable,
  input [n-1:0] in,
  output [n-1:0] state,
  output reg [m-1:0] out
);parameter n = 4; // number of states
parameter m = 2; // number of output signals

reg [n-1:0] next_state;
reg [n-1:0] current_state;

// define state transitions and output function as Boolean functions of inputs and current state
always @ (posedge clk) begin
  if (rst) begin
    current_state <= 'b0;
  end else if (enable) begin
    current_state <= next_state;
  end
end

always @ (current_state, in) begin
  case (current_state)
    4'b0001: begin // state 1
      if (in == 2'b00) begin
        out <= 2'b00;
        next_state <= 4'b0010;
      end else if (in == 2'b01) begin
        out <= 2'b01;
        next_state <= 4'b0100;
      end else begin
        out <= 2'b00;
        next_state <= 4'b0001;
      end
    end
    4'b0010: begin // state 2
      if (in == 2'b00) begin
        out <= 2'b10;
        next_state <= 4'b1000;
      end else if (in == 2'b01) begin
        out <= 2'b00;
        next_state <= 4'b0001;
      end else begin
        out <= 2'b00;
        next_state <= 4'b0010;
      end
    end
    4'b0100: begin // state 3
      if (in == 2'b00) begin
        out <= 2'b00;
        next_state <= 4'b0001;
      end else if (in == 2'b01) begin
        out <= 2'b10;
        next_state <= 4'b1000;
      end else begin
        out <= 2'b00;
        next_state <= 4'b0100;
      end
    end
    4'b1000: begin // state 4
      if (in == 2'b00) begin
        out <= 2'b01;
        next_state <= 4'b0100;
      end else if (in == 2'b01) begin
        out <= 2'b00;
        next_state <= 4'b0010;
      end else begin
        out <= 2'b00;
        next_state <= 4'b1000;
      end
    end
    default: begin
      out <= 2'b00;
      next_state <= 4'b0001;
    end
  endcase
end

// use one-hot code to represent current state
assign state = {current_state};

endmodule