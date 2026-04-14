module top_module(input in, output out);parameter CLK_DIVIDER_WIDTH = 8;
    parameter CLK_DIVIDER_VALUE = 4;

    reg [CLK_DIVIDER_WIDTH-1:0] _icounter;
    reg _internal_clk;

    assign out = _internal_clk;

    initial begin
        _icounter = {(CLK_DIVIDER_WIDTH){1'b0}};
        _internal_clk = 0;
    end

    always @(posedge in) begin
        _internal_clk =  (_icounter == {CLK_DIVIDER_VALUE} ) ? ~_internal_clk : _internal_clk;
        _icounter = (_icounter == {CLK_DIVIDER_VALUE} ) ? 0 : _icounter + 1;
    end
endmodule