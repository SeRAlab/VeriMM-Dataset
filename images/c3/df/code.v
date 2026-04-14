module register_file (
  input [n-1:0] write_data,
  input [m-1:0] reg_addr,
  input read_en,
  input write_en,
  output [n-1:0] read_data
);

parameter n = 8; // number of bits in write_data and read_data signals
parameter m = 16; // number of registers in the register file

reg [n-1:0] registers [0:m-1];

always @ (posedge clk) begin
  if (write_en) begin
    registers[reg_addr] <= write_data;
  end
end

assign read_data = (read_en) ? registers[reg_addr] : 0;

endmodule