module binary_counter (
    input clk,
    input enable,
    input reset_n,
    output [3:0] count
);
    reg [3:0] count_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count_reg <= 4'b0000;
        else if (enable)
            count_reg <= count_reg + 1;
    end

    assign count = count_reg;

endmodule