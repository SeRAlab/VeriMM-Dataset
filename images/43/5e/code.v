module top_module(clk, v_addr, v_data, v_en, v_rdy);parameter ADDRESS_WIDTH=11;
  parameter MEM_SIZE=(1<<ADDRESS_WIDTH);
  parameter DATA_WIDTH=8;
  parameter FILENAME="your_rom_data.mif";

  input                       clk;
  input [ADDRESS_WIDTH-1:0]   v_addr;
  output reg [DATA_WIDTH-1:0] v_data;
  input                       v_en;
  output reg                  v_rdy;

  (* ram_init_file = FILENAME *) reg [DATA_WIDTH-1:0]    rom [0:MEM_SIZE-1];
  
  always @(posedge clk) begin
    v_rdy <= v_en;
    if(v_en)
      v_data <= rom[v_addr];
  end

endmodule