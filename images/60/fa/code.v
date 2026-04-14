module top_module(
  input [n-1:0] ctl,
  input [m-1:0] data,
  input we,
  input cs,
  output out
);parameter n = 4; // number of control signals
parameter m = 8; // number of data signals
parameter r = 256; // total number of resistance levels

reg [7:0] mem [r-1:0]; // memory for storing resistance levels

reg [n-1:0] addr; // address for selecting resistance level
reg [7:0] res; // current resistance level

assign out = res; // output signal is the current resistance level

// write enable logic
always @ (posedge we) begin
  mem[addr] <= data;
end

// resistance level calculation
always @ (ctl or data) begin
  // calculate address based on control signals
  addr = {ctl[3:2], ctl[1:0]};
  
  // calculate resistance level based on data signals
  res = mem[addr] * data;
end

// chip select logic
always @ (cs) begin
  if (cs == 0) begin
    // digital potentiometer is enabled
    res = mem[addr] * data;
  end
  else begin
    // digital potentiometer is disabled
    res = 0;
  end
end

endmodule