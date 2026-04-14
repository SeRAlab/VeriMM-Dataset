module top_module(
  input clk,
  input [31:0] cpu_address,
  input cpu_read,
  input [31:0] cpu_readdata,
  input cpu_wait,
  input cpu_write,
  input [31:0] cpu_writedata,
  output reg [35:0] atm,
  output reg [35:0] dtm
);always @(posedge clk) begin
    if (cpu_write && !cpu_wait) begin
      atm = {4'b0101, cpu_address};
      dtm = {4'b0111, cpu_writedata};
    end else if (cpu_read && !cpu_wait) begin
      atm = {4'b0100, cpu_address};
      dtm = {4'b0110, cpu_readdata};
    end else begin
      atm = {4'b0000, cpu_address};
      dtm = {4'b0000, cpu_readdata};
    end
  end

endmodule