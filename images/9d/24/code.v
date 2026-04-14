module top_module(
  input rst_in,
  input clk,
  input rst_width,
  output reg rst_out  // Changed to reg type
);reg [1:0] rst_sync;
  reg rst_pulse;
  
  always @(posedge clk) begin
    rst_sync <= {rst_sync[0], rst_in};
  end
  
  always @(posedge clk) begin
    if (rst_sync == 2'b01) begin
      rst_pulse <= 1;
    end else begin
      rst_pulse <= 0;
    end
  end
  
  always @(posedge clk) begin
    if (rst_pulse) begin
      rst_out <= 1;
    end else begin
      rst_out <= 0;
    end
  end
  
  initial begin
    rst_sync <= 2'b11;
    rst_pulse <= 0;
    rst_out <= 0;
  end
  
endmodule