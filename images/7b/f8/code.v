module top_module(
  input wire reset,
  input wire clk,
  input wire reg_req,
  input wire reg_rd_wr_L,
  input wire [7:0] reg_addr,
  input wire [31:0] reg_wr_data,
  output reg [31:0] reg_rd_data,
  output reg reg_ack
);reg [31:0] register [255:0]; // 256 registers, each 32 bits wide

  always @(posedge clk) begin
    if (reset) begin
      reg_rd_data <= 0;
      reg_ack <= 0;
    end
    else if (reg_req) begin
      if (reg_addr > 255) begin // invalid address
        reg_rd_data <= 0;
        reg_ack <= 0;
      end
      else begin // valid address
        if (reg_rd_wr_L) begin // write operation
          register[reg_addr] <= reg_wr_data;
          reg_ack <= 1;
        end
        else begin // read operation
          reg_rd_data <= register[reg_addr];
          reg_ack <= 1;
        end
      end
    end
  end

endmodule