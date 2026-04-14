module top_module(
  input in,
  input clk,
  input reset,
  output out
);reg [1:0] phase;
  reg [7:0] local_osc;
  reg [7:0] in_i;
  reg [7:0] in_q;
  reg [7:0] i_mod;
  reg [7:0] q_mod;
  reg [7:0] i_demod;
  reg [7:0] q_demod;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      phase <= 2'b00;
      local_osc <= 8'd0;
      in_i <= 8'd0;
      in_q <= 8'd0;
      i_mod <= 8'd0;
      q_mod <= 8'd0;
      i_demod <= 8'd0;
      q_demod <= 8'd0;
    end else begin
      case (phase)
        2'b00: begin
          local_osc <= local_osc + 1;
          phase <= 2'b01;
        end
        2'b01: begin
          in_i <= in;
          i_mod <= in_i * local_osc;
          i_demod <= i_mod * local_osc;
          phase <= 2'b10;
        end
        2'b10: begin
          in_q <= in;
          q_mod <= in_q * (local_osc ^ 8'hFF);
          q_demod <= q_mod * (local_osc ^ 8'hFF);
          phase <= 2'b00;
        end
      endcase
    end
  end

  assign out = i_demod - q_demod;

endmodule