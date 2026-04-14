module shift_register (
    input [3:0] data_in,
    input shift_left,
    input clock,
    input reset,
    output [3:0] data_out
);

    reg [3:0] shift_reg;

    always @(posedge clock) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            if (shift_left) begin
                shift_reg <= {shift_reg[2:0], data_in};
            end else begin
                shift_reg <= {data_in, shift_reg[3:1]};
            end
        end
    end

    assign data_out = shift_reg;

endmodule