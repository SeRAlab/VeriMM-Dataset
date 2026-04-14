module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          pulse,
  output reg          no_pulse
);reg [7:0]           counter;
  reg                 count_en;

  parameter           THRESHOLD = 50; // threshold for pulse width detection

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      counter <= 8'b0;
      pulse <= 1'b0;
      no_pulse <= 1'b0;
      count_en <= 1'b0;
    end
    else begin
      if (a) begin
        count_en <= 1'b1;
        if (counter >= THRESHOLD) begin
          pulse <= 1'b1;
          no_pulse <= 1'b0;
        end
        else begin
          pulse <= 1'b0;
          no_pulse <= 1'b1;
        end
      end
      else begin
        count_en <= 1'b0;
        pulse <= 1'b0;
        no_pulse <= 1'b0;
        counter <= 8'b0;
      end

      if (count_en) begin
        counter <= counter + 1;
      end
    end
  end

endmodule