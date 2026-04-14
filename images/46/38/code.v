module top_module(
  input clk,
  input reset,
  input read_en,
  input write_en,
  input [15:0] address,
  input [15:0] write_data,
  output reg [15:0] read_data,
  output reg busy
);reg [15:0] memory [0:65535];
  reg [15:0] read_address;
  reg [15:0] write_address;
  reg [15:0] write_data_reg;
  reg read_operation;
  reg write_operation;
  
  always @(posedge clk) begin
    if (reset) begin
      read_data <= 16'b0;
      busy <= 1'b0;
      read_address <= 16'b0;
      write_address <= 16'b0;
      write_data_reg <= 16'b0;
      read_operation <= 1'b0;
      write_operation <= 1'b0;
    end
    else begin
      if (read_en && !write_en) begin
        read_address <= address;
        read_operation <= 1'b1;
        write_operation <= 1'b0;
        busy <= 1'b1;
      end
      else if (!read_en && write_en) begin
        write_address <= address;
        write_data_reg <= write_data;
        write_operation <= 1'b1;
        read_operation <= 1'b0;
        busy <= 1'b1;
      end
      else begin
        read_operation <= 1'b0;
        write_operation <= 1'b0;
        busy <= 1'b0;
      end
      
      if (read_operation) begin
        read_data <= memory[read_address];
      end
      
      if (write_operation) begin
        memory[write_address] <= write_data_reg;
      end
    end
  end
endmodule