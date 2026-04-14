module top_module(
    input clk,
    input [4:0] waddr,
    input [4:0] raddr,
    input [31:0] wdata,
    output reg [31:0] rdata,  // Change this to reg
    output reg wen
);reg [31:0] regs [0:31]; // Adjusted for a full 32 register file

always @(posedge clk) begin
    if (wen) begin
        regs[waddr] <= wdata;
    end
    rdata <= regs[raddr];
end

endmodule