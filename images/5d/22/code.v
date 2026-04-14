module top_module(
    input clk, wen,
    input [5:0] waddr,
    input [5:0] raddr1,
    input [5:0] raddr2,
    input [31:0] wdata,
    output reg [31:0] rdata1,  // Changed from wire to reg
    output reg [31:0] rdata2   // Changed from wire to reg
);reg [31:0] regs [0:30];

    always @(posedge clk) begin
        if (wen) begin
            regs[waddr] <= wdata;
        end
        rdata1 <= regs[raddr1];
        rdata2 <= regs[raddr2];
    end

endmodule