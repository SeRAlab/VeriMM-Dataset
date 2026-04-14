module top_module(clk, rst, inData, address, outData, writeEn);input clk, rst, writeEn;
  input [7:0] inData;
  input [1:0] address;
  output [7:0] outData;

  reg[7:0] regArr [3:0];

  always @ ( posedge clk, posedge rst ) begin
    if (rst) begin
      regArr[0] = 8'b00000000;
      regArr[1] = 8'b00000000;
      regArr[2] = 8'b00000000;
      regArr[3] = 8'b00000000;
    end
    else begin
      if (writeEn) begin
        regArr[address] <= inData;
      end
    end
  end

  assign outData = regArr[address];

endmodule