module top_module(
  input [7:0]address,
  output [7:0]data
);wire [7:0]data_memory[255:0];
assign data_memory[0]=8'b00000001;
assign data_memory[1]=8'b00000010;

assign data=data_memory[address];

endmodule