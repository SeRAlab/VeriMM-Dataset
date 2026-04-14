module top_module(
  input clk,
  input wr_en,
  input [7:0] data_in,
  input rst,
  output reg [7:0] data_out // Change output to reg type
);parameter depth = 8; // number of data items that can be stored in the memory block

reg [7:0] memory [0:depth-1]; // memory array
reg [2:0] pointer = 0; // pointer to last data item written into the memory block

always @(posedge clk) begin
  if (rst) begin
    pointer <= 0; // reset pointer
    data_out <= 0; // output 0
  end
  else begin
    case ({wr_en, pointer})
      2'b01: begin // write data_in to memory
        memory[pointer] <= data_in;
        pointer <= pointer + 1;
      end
      2'b10: begin // read last data item written to memory
        data_out <= memory[pointer-1];
        pointer <= pointer - 1;
      end
      default: data_out <= data_out; // do nothing
    endcase
  end
end

endmodule