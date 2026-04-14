module top_module(
  input [23:0] data,
  input blank,
  input hs,
  input vs,
  input clk,
  output reg [7:0] vga_data,
  output reg blank_out,
  output reg hs_out,
  output reg vs_out
);reg [1:0] cnt;
  reg [23:0] data_reg;
  reg hs_reg;
  reg hs_reg1;
  reg vs_reg;
  reg blank_reg;

  always @(posedge clk) begin
    hs_reg <= hs;
    hs_reg1 <= hs_reg;
    vs_reg <= vs;
    blank_reg <= blank;
  end

  wire sync_pulse = (hs_reg & !hs_reg1) ? 1 : 0;
  always @(posedge clk) begin
    if (sync_pulse) begin
      cnt <= 2; // sync_pulse is phase ?, 
    end
    else begin
      if (cnt == 2)
        cnt <= 0;
      else    
        cnt <= cnt+1;
    end
  end

  always @(posedge clk) begin
    if (cnt == 2)
      data_reg <= data;
  end

  always @(posedge clk) begin
    case (cnt)
      0: vga_data <= {3'b0, data_reg[7:0]};
      1: vga_data <= {3'b0, data_reg[15:8]};
      default: vga_data <= {2'b0, data_reg[23:16]};
    endcase
  end

  assign blank_out = blank_reg;
  assign hs_out = hs_reg;
  assign vs_out = vs_reg;

endmodule