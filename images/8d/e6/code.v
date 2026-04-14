module top_module(
    input   [1:0]       iv_clk,
    input   [1:0]       iv_wen,
    input   [15:0]      iv_addr,
    input   [15:0]      iv_wdata,
    output  reg [15:0]  ov_rdata  // Changed to reg to be able to assign values in always block
    );reg [15:0] bankA [0:255];
    reg [15:0] bankB [0:255];

    always @(posedge iv_clk[0]) begin
        if (iv_wen[0] == 1) begin
            bankA[iv_addr[7:0]] <= iv_wdata;
        end
        ov_rdata <= bankA[iv_addr[7:0]]; // This is now valid
    end

    always @(posedge iv_clk[1]) begin
        if (iv_wen[1] == 1) begin
            bankB[iv_addr[7:0]] <= iv_wdata;
        end
        ov_rdata <= bankB[iv_addr[7:0]]; // This is now valid
    end

endmodule