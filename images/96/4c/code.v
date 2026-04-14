module top_module(
  input            clock,
  input   [31:0]   data,
  input   [4:0]    wraddress,
  input   [4:0]    rdaddress,
  input            wren,
  output  [31:0]   q
);reg     [31:0]   ram [31:0];  // Change wire to reg
  assign  q = ram[rdaddress];

  always @(posedge clock) begin
    if (wren) begin
      ram[wraddress] <= data;  // This is now valid since ram is reg
    end
  end

endmodule