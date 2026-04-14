module top_module(
  input [1:0] address,
  input clk,
  input [7:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);reg [7:0] memory [1:0];
  reg [31:0] temp_readdata;
  reg clk_en;

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      readdata <= 0;
      memory[0] <= 0;
      memory[1] <= 0;
      temp_readdata <= 0;
    end
    else if (clk_en) begin
      readdata <= temp_readdata;
    end
  end

  always @(*) begin
    case (address)
      2'b00: memory[0] <= in_port;
      2'b01: memory[1] <= in_port;
      default: ;
    endcase
    temp_readdata = {8'h00, memory[address]};
    clk_en = 1;
  end

endmodule