module top_module(
  input write_0r,
  input [15:0] write_0d,
  output reg write_0a,
  input read_0r,
  output reg read_0a,
  output reg [15:0] read_0d,
  input read_1r,
  output reg read_1a,
  output reg [15:0] read_1d
);reg [15:0] data_0n;
  reg [15:0] read_0d_reg;

  // Write port
  always @(posedge write_0r) begin
    if (write_0r) begin
      data_0n <= write_0d;
      write_0a <= 1'b1;
    end
  end

  // First read port
  always @(posedge read_0r) begin
    if (read_0r) begin
      read_0d_reg <= data_0n;
      read_0a <= 1'b1;
    end
  end

  assign read_0d = read_0d_reg;

  // Second read port
  always @(posedge read_1r) begin
    if (read_1r) begin
      read_1a <= 1'b1;
      read_1d <= read_0d_reg;
    end
  end
  
endmodule