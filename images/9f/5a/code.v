module binary_counter_4bit(
    input clk,
    input rst,
    output [3:0] count
);

    reg [3:0] counter_reg;

    always @(posedge clk) begin
        if (!rst) begin
            counter_reg <= 4'b0000;
        end else begin
            counter_reg <= counter_reg + 1;
        end
    end

    assign count = counter_reg;

endmodule