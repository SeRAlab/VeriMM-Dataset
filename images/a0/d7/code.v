module top_module(
  input wire [1:0] address,
  input wire chipselect,
  input wire clk,
  input wire [3:0] in_port,
  input wire reset_n,
  input wire write_n,
  input wire [31:0] writedata,
  output wire irq,
  output reg [31:0] readdata  // changed wire to reg
);// Registers
  reg [3:0] d1_data_in;
  reg [3:0] d2_data_in;
  reg [3:0] edge_capture;
  reg [3:0] irq_mask;

  // Wires
  wire [3:0] data_in;
  wire [3:0] edge_detect;
  wire [3:0] read_mux_out;
  wire edge_capture_wr_strobe;

  // Assignments
  assign data_in = in_port;
  assign read_mux_out = ({4 {(address == 2)}} & irq_mask) |
                        ({4 {(address == 3)}} & edge_capture) |
                        ({4 {(address == 0)}} & data_in);
  assign irq = |(edge_capture & irq_mask);
  
  // Initialization of readdata moved to the corresponding always block
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata <= 32'b0; // Initialize readdata to 0 on reset
    end else begin
      readdata <= (clk) ? {{28{1'b0}}, read_mux_out} : readdata;
    end
  end

  // Edge detection
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      d1_data_in <= 4'b0;
      d2_data_in <= 4'b0;
      edge_capture <= 4'b0;
    end else begin
      d1_data_in <= data_in;
      d2_data_in <= d1_data_in;
      edge_capture <= edge_capture_wr_strobe ? 4'b0 : edge_detect ? 4'b1111 : edge_capture;
    end
  end

  // Interrupt mask
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      irq_mask <= 4'b0;
    end else begin
      irq_mask <= chipselect && ~write_n && (address == 2) ? writedata[3:0] : irq_mask;
    end
  end

endmodule