module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out_0,
    output reg clk_out_1,
    output reg clk_out_2,
    output reg clk_out_3
);
    reg [1:0] state;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            clk_out_0 <= 1'b0;
            clk_out_1 <= 1'b0;
            clk_out_2 <= 1'b0;
            clk_out_3 <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    clk_out_0 <= 1'b1;
                    clk_out_1 <= 1'b0;
                    clk_out_2 <= 1'b0;
                    clk_out_3 <= 1'b0;
                    state <= 2'b01;
                end
                2'b01: begin
                    clk_out_0 <= 1'b0;
                    clk_out_1 <= 1'b1;
                    clk_out_2 <= 1'b0;
                    clk_out_3 <= 1'b0;
                    state <= 2'b10;
                end
                2'b10: begin
                    clk_out_0 <= 1'b0;
                    clk_out_1 <= 1'b0;
                    clk_out_2 <= 1'b1;
                    clk_out_3 <= 1'b0;
                    state <= 2'b11;
                end
                2'b11: begin
                    clk_out_0 <= 1'b0;
                    clk_out_1 <= 1'b0;
                    clk_out_2 <= 1'b0;
                    clk_out_3 <= 1'b1;
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule