module top_module(
  input clk,
  input reset,
  input count_dir,
  input [31:0] max_count,
  output [31:0] count,
  output reg overflow  // Change here: 'overflow' is now declared as a reg
);reg [31:0] count_reg;
  wire [31:0] count_next;
  
  assign count_next = count_reg + (count_dir ? 1 : -1);
  
  always @(posedge clk) begin
    if (reset) begin
      count_reg <= 0;
      overflow <= 0; // Now valid as 'overflow' is a reg
    end else begin
      count_reg <= (count_next <= max_count) ? count_next : 0;
      overflow <= (count_next > max_count); // Now valid as 'overflow' is a reg
    end
  end
  
  assign count = count_reg;
  
endmodule