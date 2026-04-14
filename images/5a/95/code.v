module top_module(
    input in,
    input rst,
    input en,
    input clk,      // Added missing clk input
    output out
);reg [3:0] delay_reg;
    wire [3:0] next_delay_reg;

    always @(posedge clk) begin
        if (rst) begin
            delay_reg <= 4'b0000;
        end else if (en) begin
            delay_reg <= next_delay_reg;
        end
    end

    assign next_delay_reg[0] = in;
    assign next_delay_reg[1] = delay_reg[0];
    assign next_delay_reg[2] = delay_reg[1];
    assign next_delay_reg[3] = delay_reg[2];

    assign out = delay_reg[3];

endmodule