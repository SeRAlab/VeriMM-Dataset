module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input valid_a,
  output ready_a,
  input ready_b,
  input [2:0] threshold,
  output reg valid_b,
  output reg [11:0] data_out_binary,
  output reg [3:0] data_out_bcd
);// Internal signals
  reg [11:0] accumulator;
  reg [3:0] bcd_value;
  reg [3:0] bcd_temp;
  reg [2:0] count;

  // Valid-ready handshake
  wire valid_a_next;
  wire ready_b_next;
  assign valid_a_next = (accumulator >= {4'b0, threshold});
  assign ready_a = ~valid_b;
  assign ready_b_next = ~valid_a_next;
  
  // Data accumulation
  always @(posedge clk) begin
    if (reset) begin
      accumulator <= 12'b0;
      count <= 3'b0;
      bcd_value <= 4'b0;
      bcd_temp <= 4'b0;
    end else if (valid_a & ready_b) begin
      accumulator <= accumulator + data_in;
      count <= count + 1;
      if (count == 4) begin
        bcd_temp <= accumulator[11:8];
        bcd_value <= bcd_value + bcd_temp;
        bcd_value <= {bcd_value[2:0], bcd_value[3]};
        bcd_temp <= accumulator[7:4];
        bcd_value <= bcd_value + bcd_temp;
        bcd_value <= {bcd_value[2:0], bcd_value[3]};
        bcd_temp <= accumulator[3:0];
        bcd_value <= bcd_value + bcd_temp;
        bcd_value <= {bcd_value[2:0], bcd_value[3]};
        count <= 3'b0;
        accumulator <= 12'b0;
      end
    end
  end

  // Output assignment
  always @(posedge clk) begin
    if (reset) begin
      data_out_binary <= 12'b0;
      data_out_bcd <= 4'b0;
    end else if (valid_a & ready_b) begin
      data_out_binary <= accumulator;
      data_out_bcd <= bcd_value;
    end
  end

  // Ready signal control
  reg ready_b_reg; // Use a reg to hold the ready_b state
  assign ready_b = ready_b_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      ready_b_reg <= 1'b1;
    end else begin
      ready_b_reg <= ready_b_next;
    end
  end

endmodule