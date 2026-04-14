module top_module(
  input CLKIN,
  output reg CLKFX,      // changed to reg
  output reg LOCKED,     // changed to reg
  input RST,
  output reg [7:0] STATUS
);reg [5:0] counter;
  reg locked_reg;
  reg [2:0] duty_cycle_correction;

  always @(posedge CLKIN or posedge RST) begin
    if (RST) begin
      counter <= 0;
      STATUS <= 8'b0;
      duty_cycle_correction <= 3'b0;
    end else begin
      counter <= counter + 1;
      if (counter == 5'd11) begin
        counter <= 0;
        duty_cycle_correction <= duty_cycle_correction + 1;
        if (duty_cycle_correction == 3'd6) begin
          duty_cycle_correction <= 3'b0;
        end
      end
    end
  end

  always @(posedge CLKIN or posedge RST) begin
    if (RST) begin
      STATUS <= 8'b0;
      locked_reg <= 1'b0;
    end else begin
      STATUS[0] <= locked_reg;
      STATUS[1] <= CLKFX;
      STATUS[2] <= duty_cycle_correction[0];
      STATUS[3] <= duty_cycle_correction[1];
      STATUS[4] <= duty_cycle_correction[2];
      STATUS[5] <= 1'b0;
      STATUS[6] <= 1'b0;
      STATUS[7] <= 1'b0;
      if (!locked_reg && STATUS[0]) begin
        locked_reg <= 1'b1;
      end
    end
  end

  always @(posedge CLKIN or posedge RST) begin
    if (RST) begin
      CLKFX <= 1'b0;
      LOCKED <= 1'b0;
    end else begin
      if (counter == 5'd0) begin
        CLKFX <= ~CLKFX;
      end
      if (duty_cycle_correction == 3'd3) begin
        CLKFX <= ~CLKFX;
      end
      if (counter == 5'd0 || counter == 5'd5) begin
        LOCKED <= 1'b0;
      end else if (counter == 5'd2 || counter == 5'd7) begin
        LOCKED <= 1'b1;
      end
    end
  end

endmodule