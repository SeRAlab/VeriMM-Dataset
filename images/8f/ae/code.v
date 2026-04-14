module debouncer(
    input clk,
    input button,
    output reg debounced
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[2:0], button};
        if (shift_reg == 4'b1111) begin
            debounced <= 1;
        end else begin
            debounced <= 0;
        end
    end

endmodule