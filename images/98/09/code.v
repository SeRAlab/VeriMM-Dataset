module top_module(
    input clk,
    input rst,
    input ce,
    input we,
    input oe,
    input [6:0] addr,
    input [31:0] di,
    output [31:0] doq
);reg [31:0] mem [0:127]; // RAM content
    reg [6:0] addr_reg; // RAM address register

    // Data output drivers
    assign doq = (oe) ? mem[addr_reg] : {32{1'b0}};

    // RAM address register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr_reg <= 7'b0;
        end else if (ce) begin
            addr_reg <= addr;
        end
    end

    // RAM write
    always @(posedge clk) begin
        if (ce && we) begin
            mem[addr_reg] <= di;
        end
    end

endmodule