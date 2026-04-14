module top_module(
  input clk,
  input rd_en,
  input [5:0] I1,
  input [0:0] I2,
  output reg empty,
  output reg [0:0] E,
  output reg [0:0] O1,
  output reg O2,
  output reg ENB,
  output reg [5:0] O3,
  output reg [1:0] Q
);reg [5:0] mem [0:31];
  reg [4:0] write_ptr = 0;
  reg [4:0] read_ptr = 0;
  reg [4:0] count = 0;

  always @(posedge clk) begin
    if (ENB) begin
      if (rd_en && !empty) begin
        O1 <= mem[read_ptr][5];
        O2 <= mem[read_ptr][4];
        O3 <= mem[read_ptr];
        read_ptr <= read_ptr + 1;
        count <= count - 1;
        if (count == 0) begin
          empty <= 1;
          E <= 0;
        end
      end
      else begin
        O1 <= 0;
        O2 <= 0;
        O3 <= 0;
      end

      if (!rd_en && count < 32) begin
        mem[write_ptr] <= {I1, I2};
        write_ptr <= write_ptr + 1;
        count <= count + 1;
        if (count == 32) begin
          E <= 1;
        end
        if (empty) begin
          empty <= 0;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (ENB) begin
      if (count == 0) begin
        Q <= 2'b00;
      end
      else if (count == 32) begin
        Q <= 2'b10;
      end
      else begin
        Q <= 2'b01;
      end
    end
  end

  always @(posedge clk) begin
    if (ENB) begin
      ENB <= 1;
    end
    else if (empty) begin
      ENB <= 0;
    end
  end

endmodule