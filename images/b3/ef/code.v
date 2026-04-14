module top_module(
  // inputs:
  address,
  chipselect,
  clk,
  reset_n,
  write_n,
  writedata,

  // outputs:
  out_port,
  readdata
);output  [7:0] out_port;
  output  [31:0] readdata;
  input   [1:0] address;
  input   chipselect;
  input   clk;
  input   reset_n;
  input   write_n;
  input   [31:0] writedata;

  reg [7:0] data_out;
  reg [31:0] buffer;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      data_out <= 0;
      buffer <= 0;
    end else begin
      if (chipselect && !write_n && (address == 2'b00)) begin
        buffer[31:8] <= writedata[31:8];
        buffer[7:0] <= writedata[7:0];
      end
      data_out <= buffer[7:0];
    end
  end

  assign out_port = data_out;
  assign readdata = {32'b0, buffer[31:8]};

endmodule