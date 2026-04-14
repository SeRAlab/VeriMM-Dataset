module top_module(
    input A,
    output X,
    input [7:0] DELAY,
    input clk  // Added clk input
);reg [7:0] counter;
    reg [7:0] shift_reg;
    reg X_reg;

    always @(posedge clk) begin
        if (counter < DELAY) begin
            shift_reg <= {shift_reg[6:0], A};
            counter <= counter + 1;
        end else begin
            X_reg <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], X_reg};
        end
    end

    assign X = X_reg;

endmodule