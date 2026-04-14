module top_module( 
    input clock, 
    input reset, 
    input enable, 
    input taken_i, 
    output reg prediction_o 
);reg [1:0] STATE_reg; // Register to hold the state
  wire n5, n6, n8, n10, n12, n13, n14;
  wire [1:0] next_STATE;

  // 2-bit saturating counter
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      STATE_reg <= 2'b01;
    end else if (enable) begin
      case (STATE_reg)
        2'b00: if (taken_i) STATE_reg <= 2'b01; else STATE_reg <= 2'b00;
        2'b01: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b00;
        2'b10: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b01;
        2'b11: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b10;
      endcase
    end
  end

  // Calculate next state
  assign next_STATE[0] = enable ? (taken_i ? (STATE_reg == 2'b01 ? 1'b1 : 1'b0) : 1'b0) : 1'b0;
  assign next_STATE[1] = enable ? (taken_i ? (STATE_reg == 2'b11 ? 1'b1 : 1'b0) : 1'b0) : 1'b0;

  // State updates
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      prediction_o <= 1'b0;
    end else if (enable) begin
      prediction_o <= next_STATE[1];
    end
  end

endmodule