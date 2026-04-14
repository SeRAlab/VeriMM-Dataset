module top_module(
    input [31:0] PC4,
    input [31:0] addr,
    output wire [31:0] address
);assign address[31:28] = PC4[31:28];
    assign address[27:2] = addr[27:2] << 2;
    assign address[1:0] = 2'b00;
endmodule