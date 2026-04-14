module top_module(
  input   [1:0] address,
  input         chipselect,
  input         clk,
  input         in_port,
  input         reset_n,
  input         write_n,
  input  [31:0] writedata,
  output        irq,
  output reg [31:0] readdata  // Changed output to reg to allow assignment in always block
);wire clk_en;
  reg  d1_data_in;
  reg  d2_data_in;
  wire data_in;
  reg  edge_capture;
  wire edge_capture_wr_strobe;
  wire edge_detect;
  reg  irq_reg; // Changed to reg type
  reg  irq_mask;
  wire read_mux_out;

  assign clk_en = 1;
  assign read_mux_out = ({1 {(address == 0)}} & data_in) |
                        ({1 {(address == 2)}} & irq_mask) |
                        ({1 {(address == 3)}} & edge_capture);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      readdata <= 0;
    end else if (clk_en) begin
      readdata <= read_mux_out;  // Corrected here
    end
  end

  assign data_in = in_port;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      irq_mask <= 0;
    end else if (chipselect && !write_n && (address == 2)) begin
      irq_mask <= writedata;
    end
  end

  assign edge_detect = d1_data_in & ~d2_data_in;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      edge_capture <= 0;
    end else if (clk_en) begin
      if (edge_capture_wr_strobe) begin
        edge_capture <= 0;
      end else if (edge_detect) begin
        edge_capture <= -1;
      end
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      d1_data_in <= 0;
      d2_data_in <= 0;
    end else if (clk_en) begin
      d1_data_in <= data_in;
      d2_data_in <= d1_data_in;
    end
  end

  assign edge_capture_wr_strobe = chipselect && !write_n && (address == 3);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      irq_reg <= 0;
    end else begin
      irq_reg <= |(edge_capture & irq_mask);
    end
  end

  assign irq = irq_reg; // Assign the reg value to the output net

endmodule