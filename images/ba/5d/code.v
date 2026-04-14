module top_module(
  input         clock,
  input  [3:0]  io_w_addr,
  input  [31:0] io_w_data,
  input         io_w_en,
  input  [3:0]  io_r_addr,
  output [31:0] io_output_data
);reg [31:0] memory [0:15];
  assign io_output_data = memory[io_r_addr];
  
  always @(posedge clock) begin
    if(io_w_en) begin
      memory[io_w_addr] <= io_w_data;
    end
  end
endmodule