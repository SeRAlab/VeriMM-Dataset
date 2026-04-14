module top_module(
    inclk0,
    c0
);parameter   integer   DIV_FACTOR = 2;

    input       inclk0;
    output      c0;

    reg         [31:0]   counter;
    reg                   clk_out;

    always @(posedge inclk0) begin
        if (counter == DIV_FACTOR - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end

    assign c0 = clk_out;

endmodule