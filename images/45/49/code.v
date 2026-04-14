module binary_counter (
    input clk,
    output [3:0] count
);

    reg [3:0] count_reg;

    always @(posedge clk) begin
        count_reg <= count_reg + 1;
    end

    assign count = count_reg;

endmodule