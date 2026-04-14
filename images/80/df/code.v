module top_module(
  input clk,
  input we,
  input din,
  input rst,
  output reg dout,
  output reg empty,
  output reg full
);parameter DEPTH = 8; // depth of the memory block

reg [7:0] mem [0:DEPTH-1]; // register array to store the data inputs
reg [3:0] ptr; // pointer to track the last data input that was written to the memory block

always @(posedge clk) begin
  if (rst) begin
    ptr <= 0;
    dout <= 0;
    empty <= 1;
    full <= 0;
  end else begin
    if (we && !full) begin
      mem[ptr] <= din;
      empty <= 0;
      if (ptr == DEPTH-1) begin
        ptr <= 0;
        full <= 1;
      end else begin
        ptr <= ptr + 1;
        full <= 0;
      end
    end else begin
      if (empty) begin
        dout <= 0;
      end else begin
        dout <= mem[ptr];
        if (ptr == 0) begin
          empty <= 1;
        end else begin
          empty <= 0;
        end
        full <= 0;
        ptr <= ptr - 1;
      end
    end
  end
end

endmodule