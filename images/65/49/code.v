module top_module(
  input wire clk,
  input wire enable_i,
  input wire reset_i,
  input wire advance_i,
  input wire direction_i,
  input wire break_i,
  input wire align_i, 
  output wire [3:0] state_o
);reg [2:0] state_number;
reg [3:0] state_table [7:0];

always @(posedge clk) begin
  if (reset_i) begin
    state_number <= 3'b000;
    state_table[0] <= 4'b0110;
    state_table[1] <= 4'b0100;
    state_table[2] <= 4'b1100;
    state_table[3] <= 4'b1000;
    state_table[4] <= 4'b1010;
    state_table[5] <= 4'b0010;
    state_table[6] <= 4'b0000;
    state_table[7] <= 4'b1110;
  end else if (enable_i) begin
    if (advance_i && direction_i) begin
      if (state_number == 3'b101) begin
        state_number <= 3'b000;
      end else begin
        state_number <= state_number + 1;
      end
    end else if (advance_i && !direction_i) begin
      if (state_number == 3'b000) begin
        state_number <= 3'b101;
      end else begin
        state_number <= state_number - 1;
      end
    end else if (break_i) begin
      state_number <= 3'b110;
    end else if (align_i) begin
      state_number <= 3'b111;
    end
  end
end

assign state_o = state_table[state_number];

endmodule