module top_module(douta,
    clka,
    addra,
    dina,
    wea);output reg [0:0] douta; // changed to output reg
  input clka;
  input [13:0] addra;
  input [0:0] dina;
  input [0:0] wea;

  reg [0:0] mem[0:16383]; // 14-bit addressable memory block

  always @(posedge clka) begin
    if (wea) begin // write operation
      mem[addra] <= dina;
    end else begin // read operation
      douta <= mem[addra];
    end
  end
endmodule