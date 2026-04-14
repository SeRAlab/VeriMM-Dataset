module ring_counter_4bit(
    input clk,
    input rst,
    output [3:0] count
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!rst) begin
            shift_reg <= 4'b1000;
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
    end

    assign count = shift_reg;

endmodule