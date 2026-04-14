module top_module(
  input clk,
  input rst,
  input [7:0] data1,
  input [7:0] data2,
  output reg eq,
  output reg done
);reg [7:0] data1_reg;
  reg [7:0] data2_reg;
  reg [3:0] byte_cnt;
  
  always @(posedge clk) begin
    if (rst) begin
      eq <= 0;
      done <= 0;
      byte_cnt <= 0;
      data1_reg <= 0;
      data2_reg <= 0;
    end
    else begin
      if (byte_cnt == 0) begin
        data1_reg <= data1;
        data2_reg <= data2;
        byte_cnt <= 1;
      end
      else if (byte_cnt < 7) begin
        byte_cnt <= byte_cnt + 1;
      end
      else begin
        if (data1_reg == data2_reg) begin
          eq <= 1;
        end
        else begin
          eq <= 0;
        end
        done <= 1;
        byte_cnt <= 0;
      end
    end
  end
  
endmodule