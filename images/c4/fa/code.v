module memory_interface(clka, wea, addra, dina, douta);
  parameter MEM_SIZE = 2**14; // 14-bit address gives 2^14 memory locations
  parameter MEM_WIDTH = 8; // each memory location holds 1 byte of data
  reg [MEM_WIDTH-1:0] mem [0:MEM_SIZE-1]; // declare memory array

  input clka;
  input [0:0] wea;
  input [13:0] addra;
  input [11:0] dina;
  output [11:0] douta;

  assign douta = (wea == 1'b1) ? 12'hzzz : mem[addra][11:0]; // output data on douta

  always @(posedge clka) begin
    if (wea == 1'b1) begin // write to memory
      mem[addra][7:0] <= dina[7:0];
    end
  end

endmodule