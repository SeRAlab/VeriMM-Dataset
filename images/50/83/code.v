module dual_port_ram_16x8(clk, we_a, addr_a, data_in_a, addr_b, data_out_b);
     input clk;
     input we_a;
     input [3:0] addr_a;
     input [7:0] data_in_a;
     input [3:0] addr_b;
     output reg [7:0] data_out_b;

     reg [7:0] ram [15:0];

     always @(posedge clk) begin
          if (we_a)
               ram[addr_a] <= data_in_a;
          data_out_b <= ram[addr_b];
     end
endmodule