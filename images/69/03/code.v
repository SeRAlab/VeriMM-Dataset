module top_module(
  input               clk,
  input               rst_n,
  input               a,
  input               b,
  input               sel_b1,
  output reg          out_always,
  output reg          rise,
  output reg          down,
  output reg          final_out
);reg prev_input;
  reg [1:0] state;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      case (state)
        2'b00: begin
          if (a != prev_input && b != prev_input) begin
            state <= 2'b00;
          end else if (a > prev_input && b > prev_input) begin
            state <= 2'b01;
            rise <= 1'b1;
          end else if (a < prev_input && b < prev_input) begin
            state <= 2'b10;
            down <= 1'b1;
          end
          prev_input <= a | b;
        end
        2'b01: begin
          if (a > prev_input && b > prev_input) begin
            state <= 2'b01;
          end else begin
            state <= 2'b00;
            rise <= 1'b0;
          end
          prev_input <= a | b;
        end
        2'b10: begin
          if (a < prev_input && b < prev_input) begin
            state <= 2'b10;
          end else begin
            state <= 2'b00;
            down <= 1'b0;
          end
          prev_input <= a | b;
        end
      endcase
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      out_always <= 1'b0;
    end else begin
      if (sel_b1) begin
        out_always <= b;
      end else begin
        out_always <= a;
      end
    end
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      final_out <= 1'b0;
    end else begin
      final_out <= out_always & (rise | down);
    end
  end

endmodule