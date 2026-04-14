module top_module(
    input   rst,
    input   clk,
    output  reg rst_n
);reg r;

always @(negedge clk)
    if( rst ) begin
        r     <= 1'b0;
        rst_n <= 1'b0;
    end else begin
        { rst_n, r } <= { r, 1'b1 };
    end

endmodule