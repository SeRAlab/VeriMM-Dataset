module pll_2x (
    input wire clk_ref,
    input wire reset,
    input wire control,
    output reg clk_out
);
    reg [1:0] state;

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            clk_out <= 0;
        end else begin
            if (control) begin
                state <= state + 1;
                if (state == 2'b11) begin
                    clk_out <= ~clk_out;
                    state <= 2'b00;
                end
            end
        end
    end
endmodule