module delay_gate(
    input A,
    input reset,
    output reg X,
    input clk
);

    reg [3:0] delay_reg;

    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 0;
            X <= 0;
        end else begin
            delay_reg <= {delay_reg[2:0], A};
            X <= delay_reg[3];
        end
    end

endmodule