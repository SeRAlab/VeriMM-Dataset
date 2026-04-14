module top_module(
  input [39:0] data,
  input [4:0] rdaddress,
  input rdclock,
  input [4:0] wraddress,
  input wrclock,
  input wren,
  input reset,
  output [39:0] q
);reg [39:0] mem_array [0:31]; // Change wire to reg
  reg [39:0] q_reg;
  
  assign q = q_reg;
  
  always @ (posedge rdclock) begin
    if (reset) begin
      q_reg <= 40'd0;
    end else begin
      q_reg <= mem_array[rdaddress];
    end
  end
  
  always @ (posedge wrclock) begin
    if (wren) begin // Correct the condition to check for write enable
      mem_array[wraddress] <= data; // Now valid since mem_array is reg
    end
  end

endmodule