module top_module(
  input clk,
  input we1, we2,
  input re1, re2,
  input [addr_width-1:0] addr1, addr2,
  input [m-1:0] data_in1, data_in2,
  output reg [m-1:0] data_out1, data_out2
);parameter n = 1024; // size of memory array
parameter m = 8; // width of data bus
localparam addr_width = $clog2(n); // Calculate address width

// memory array declaration
reg [m-1:0] mem [0:n-1];

// write logic for port 1
always @(posedge clk) begin
  if (we1) begin
    mem[addr1] <= data_in1;
  end
end

// write logic for port 2
always @(posedge clk) begin
  if (we2) begin
    mem[addr2] <= data_in2;
  end
end

// read logic for port 1
always @(posedge clk) begin
  if (re1) begin
    data_out1 <= mem[addr1];
  end else begin
    data_out1 <= 0; // Output zero when not reading
  end
end

// read logic for port 2
always @(posedge clk) begin
  if (re2) begin
    data_out2 <= mem[addr2];
  end else begin
    data_out2 <= 0; // Output zero when not reading
  end
end

endmodule