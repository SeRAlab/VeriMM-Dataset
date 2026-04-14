module top_module(
    out,
    O1,
    sel,
    rd_clk,
    Q
);output [11:0] out;
    output [11:0] O1;
    input sel;
    input rd_clk;
    input Q;

    reg [11:0] out;
    reg [11:0] O1;

    always @(posedge rd_clk) begin
        if(Q) begin
            out <= 12'h0;
            O1 <= 12'h0;
        end else if(sel) begin
            out <= out + 1;
            O1 <= out;
        end
    end

endmodule