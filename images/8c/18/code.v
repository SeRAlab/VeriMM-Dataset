module top_module(
    input [7:0] address,
    input clken,
    input clock,
    input [11:0] data,
    input wren,
    output reg [11:0] q
);reg [15:0] memory [0:15][0:1023];

always @(posedge clock) begin
    if (clken) begin
        q <= memory[address[7:4]][address[3:0]];
    end
    if (wren && clken) begin
        memory[address[7:4]][address[3:0]] <= data;
    end
end

endmodule