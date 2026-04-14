module top_module(
  input clk,
  input [19:0] addr,
  output reg [35:0] data
);reg [35:0] mem [0:(1<<20)-1]; // Initialize memory with all zeros
  
  always @(posedge clk) begin
    if (addr >= 0 && addr < (1<<20)) begin // Check if address is in range
      data <= mem[addr];
    end else begin
      data <= 36'd0;
    end
  end
  
endmodule