module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input writedata,
  output reg out_port,
  output reg readdata
);reg [1:0] register_data;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      register_data <= 2'b00;
    end else begin
      if (chipselect) begin
        if (~write_n && (address == 2'b00)) begin
          register_data <= writedata;
        end
        readdata <= (address == 2'b00) ? register_data : 1'b0;
      end else begin
        readdata <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (chipselect && ~write_n && (address == 2'b00)) begin
      out_port <= writedata;
    end else begin
      out_port <= register_data[0];
    end
  end

endmodule