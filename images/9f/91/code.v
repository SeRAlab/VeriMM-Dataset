module top_module(
  input [1:0] address,
  input clk,
  input [7:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);reg [31:0] reg_data; // register to store data

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      reg_data <= 0;
      readdata <= 0;
    end
    else begin
      if (address == 2'b00) begin // write operation
        reg_data <= in_port;
      end
      else if (address == 2'b01) begin // read operation
        readdata <= reg_data;
      end
    end
  end

endmodule