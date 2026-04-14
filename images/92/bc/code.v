module top_module(
    input clk,
    input write_enable,
    input [4:0] read_address1, read_address2, write_address3,
    input [31:0] write_data3,
    output [31:0] read_data1, read_data2
    );reg [31:0] rf[31:0];

always @ (posedge clk)
    if (write_enable)  rf[write_address3] <= write_data3;
  
assign read_data1 = (read_address1 != 0) ? rf[read_address1] : 0;    
assign read_data2 = (read_address2 != 0) ? rf[read_address2] : 0;    
    
endmodule