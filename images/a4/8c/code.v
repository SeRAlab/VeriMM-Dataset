module top_module(
  input clk,
  input rst_n, // Active-low reset input
  input write_en, // Write enable signal
  input [7:0] write_addr, // Address input for write port
  input [3:0] in1, // First 4-bit input for the 2-to-1 multiplexer
  input [3:0] in2, // Second 4-bit input for the 2-to-1 multiplexer
  input select, // Select input for the 2-to-1 multiplexer
  input read_en, // Read enable signal
  input [7:0] read_addr, // Address input for read port
  output reg [3:0] read_data // 4-bit output from the read port
);reg [3:0] ram [0:7]; // True dual-port RAM with depth of 8 and bit width of 4 bits

// Initialize RAM with all data set to 0000
integer i;
initial begin
  for (i = 0; i < 8; i = i + 1) begin
    ram[i] = 4'b0000;
  end
end

// Write port
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    // Reset RAM to all 0000
    for (i = 0; i < 8; i = i + 1) begin
      ram[i] <= 4'b0000;
    end
  end else if (write_en && (write_addr < 8)) begin
    // Write input data from selected input of 2-to-1 mux to specified address
    ram[write_addr] <= select ? in2 : in1;
  end
end

// Read port
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    read_data <= 4'b0000;
  end else if (read_en && (read_addr < 8)) begin
    // Read data stored at specified address and perform AND operation
    read_data <= ram[read_addr] & 4'b1100;
  end
end

endmodule