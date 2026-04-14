module top_module(
        clk,
        rce,
        ra,
        rq,
        wce,
        wa,
        wd
);parameter AWIDTH = 11;
        parameter DWIDTH = 8;

        input  			clk;
        input                   rce;
        input      [AWIDTH-1:0] ra;
        output reg [DWIDTH-1:0] rq;
        input                   wce;
        input      [AWIDTH-1:0] wa;
        input      [DWIDTH-1:0] wd;

        reg [DWIDTH-1:0] mem [0:7][0:2047];

        always @(posedge clk) begin
                if (rce) begin
                        rq <= mem[ra[7:3]][ra[2:0]];
                end
                if (wce) begin
                        mem[wa[7:3]][wa[2:0]] <= wd;
                end
        end

endmodule