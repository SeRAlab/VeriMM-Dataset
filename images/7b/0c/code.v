module gray_counter_3bit(
    input clk,
    input rst,
    output [2:0] count
);

    reg [2:0] counter_reg;

    always @(posedge clk) begin
        if (rst) begin
            counter_reg <= 3'b000;
        end else begin
            counter_reg <= counter_reg + 1;
        end
    end

    assign count = counter_reg ^ (counter_reg >> 1);

endmodule