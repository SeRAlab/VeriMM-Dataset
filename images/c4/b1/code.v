module register_file (
    input clk, wen,
    input [5:0] waddr,
    input [5:0] raddr1,
    input [5:0] raddr2,
    input [31:0] wdata,
    output reg [31:0] rdata1,
    output reg [31:0] rdata2
);

    reg [31:0] regs [0:31];

    always @(posedge clk) begin
        if (wen) begin
            regs[waddr] <= wdata;
        end
    end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];

endmodule