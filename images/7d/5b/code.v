module top_module(address1, address2, address3, rs1, rs2, wr, we, clk);input [4:0] address1, address2, address3;
input clk;
input we;
input [31:0] wr;
output [31:0] rs1, rs2;

reg [31:0] data[0:31];

always @(posedge clk) begin
    if(we)
        data[address3] <= wr;
end

assign rs1 = (address1 == 5'b00000) ? 0 : data[address1];
assign rs2 = (address2 == 5'b00000) ? 0 : data[address2];

endmodule