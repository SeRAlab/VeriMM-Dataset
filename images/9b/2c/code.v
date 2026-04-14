module down_counter_5bit(
    input clk,
    input rst,
    output [4:0] count
);

    reg [4:0] counter_reg;

    always @(posedge clk) begin
        if (!rst) begin
            counter_reg <= 5'b11111;
        end else begin
            counter_reg <= counter_reg - 1;
        end
    end

    assign count = counter_reg;

endmodule