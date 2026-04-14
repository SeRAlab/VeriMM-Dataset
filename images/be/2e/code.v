module top_module(
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    input select,           // Control input to choose between shift register and D flip-flop
    output [7:0] q
);reg [7:0] shift_reg;
    reg [7:0] d_ff;

    always @(posedge clk, negedge reset) begin
        if (reset == 1'b0) begin
            shift_reg <= 8'h34;
            d_ff <= 8'h34;
        end else begin
            if (select == 1'b1) begin
                shift_reg <= {shift_reg[6:0], d};
            end else begin
                d_ff <= d;
            end
        end
    end

    assign q = (select == 1'b1) ? shift_reg : d_ff;

endmodule