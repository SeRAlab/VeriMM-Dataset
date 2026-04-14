module top_module(q, qbar, clock, data, PREbar, CLRbar, Wen);input  clock;
    input  [31:0] data;
    input  PREbar;
    input  CLRbar;
    output Wen;
    output [31:0] q, qbar;
    reg    [31:0] q;
    reg    Wen;

    always @(posedge clock) begin
        if (PREbar == 0) begin
            q <= 32'hFFFFFFFF;
        end else if (CLRbar == 0) begin
            q <= 0;
        end else if (Wen == 1) begin
            q <= data;
        end
    end

    assign qbar = ~q;
    assign Wen = (PREbar == 1 && CLRbar == 1);

endmodule