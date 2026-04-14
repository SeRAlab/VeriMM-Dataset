module top_module(
                    input wire           clk,

                    input wire  [07 : 0] read_addr0,
                    output wire [31 : 0] read_data0,

                    input wire  [07 : 0] read_addr1,
                    output wire [31 : 0] read_data1,

                    input wire           wr,
                    input wire  [07 : 0] write_addr,
                    input wire  [31 : 0] write_data
                   );reg [31 : 0] mem [0 : 255];
  reg [31 : 0] tmp_read_data0;
  reg [31 : 0] tmp_read_data1;

  assign read_data0 = tmp_read_data0;
  assign read_data1 = tmp_read_data1;

  always @ (posedge clk)
    begin : reg_mem
      if (wr)
        mem[write_addr] <= write_data;

      tmp_read_data0 <= mem[read_addr0];
      tmp_read_data1 <= mem[read_addr1];
    end

endmodule