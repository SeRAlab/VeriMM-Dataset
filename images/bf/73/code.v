module johnson_counter_8bit(
    input clk,
    input rst,
    output [7:0] count
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 8'b11111111;
        end else begin
            shift_reg <= {shift_reg[6:0], ~shift_reg[7]};
        end
    end

    assign count = shift_reg;

endmodule