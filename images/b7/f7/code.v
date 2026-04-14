module top_module(
  input wire clk,
  input wire rst,
  input wire extClock_mode,
  input wire wrDivider,
  input wire [23:0] config_data,
  input wire sti_valid,
  input wire [31:0] sti_data,
  output reg sto_valid,
  output reg [31:0] sto_data,
  output reg ready50
);// System signals
parameter integer DW = 32;
parameter integer CW = 24;

// Registers
reg next_sto_valid;
reg [DW-1:0] next_sto_data;
reg [CW-1:0] divider, next_divider;
reg [CW-1:0] counter, next_counter;

// Wire
wire counter_zero = ~|counter;

// Generate slow sample reference
initial begin
  divider = 0;
  counter = 0;
  sto_valid = 0;
  sto_data = 0;
end

always @(posedge clk) begin
  divider <= next_divider;
  counter <= next_counter;
  sto_valid <= next_sto_valid;
  sto_data <= next_sto_data;
end

always @* begin
  next_divider = divider;
  next_counter = counter;
  next_sto_valid = 1'b0;
  next_sto_data = sto_data;

  if (extClock_mode) begin
    next_sto_valid = sti_valid;
    next_sto_data = sti_data;
  end
  else if (sti_valid && counter_zero) begin
    next_sto_valid = 1'b1;
    next_sto_data = sti_data;
  end

  // Manage counter divider for internal clock sampling mode
  if (wrDivider) begin
    next_divider = config_data[CW-1:0];
    next_counter = next_divider;
    next_sto_valid = 1'b0;
  end
  else if (sti_valid) begin
    if (counter_zero) begin
      next_counter = divider;
    end
    else begin
      next_counter = counter - 1'b1;
    end
  end
end

// Generate ready50 50% duty cycle sample signal
always @(posedge clk) begin
  if (wrDivider) begin
    ready50 <= 1'b0;
  end
  else if (counter_zero) begin
    ready50 <= 1'b1;
  end
  else if (counter == divider[CW-1:1]) begin
    ready50 <= 1'b0;
  end
end

endmodule