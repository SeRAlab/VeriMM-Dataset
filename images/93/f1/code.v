module top_module(address, data, read, out_address, out_data, out_read);input [31:0] address;
  input [127:0] out_data;
  output [127:0] data;
  output [31:0] out_address;
  input read;
  output out_read;
  
  reg [127:0] icache [63:0];
  reg [31:0] tag [63:0];
  reg [127:0] r_data;
  reg [31:0] r_out_address;
  reg r_out_read;
  integer i;
  
  assign data = r_data;
  assign out_read = r_out_read;
  assign out_address = r_out_address;
  
  always @(posedge read)
  begin
    r_out_read <= 0;
    if(tag[address[12:6]] === address[31:13])
    begin
      r_data <= icache[address[12:6]];
    end
    else
    begin
      r_out_read <= 1;
      r_out_address <= address;
      #0.001
      icache[address[12:6]] <= out_data;
      tag[address[12:6]] <= address[31:13];
      r_data <= out_data;

      for(i=0; i<64; i=i+1)
      begin
        #0.001
        r_out_address <= address / 64 * 64 + i;
        #0.001
        icache[out_address[12:6]] <= out_data;
        tag[out_address[12:6]] <= out_address[31:13];
      end
    end
  end
endmodule