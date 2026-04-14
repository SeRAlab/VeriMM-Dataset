module top_module(
    input [31:0] in,
    output [31:0] out
);reg [7:0] byte0, byte1, byte2, byte3;
reg [31:0] temp;

// Pipeline stage 1
assign byte0 = in[7:0];
assign byte1 = in[15:8];
assign byte2 = in[23:16];
assign byte3 = in[31:24];

// Pipeline stage 2
assign temp[7:0] = byte3;
assign temp[15:8] = byte2;
assign temp[23:16] = byte1;
assign temp[31:24] = byte0;

// Pipeline stage 3
assign out = temp;

endmodule