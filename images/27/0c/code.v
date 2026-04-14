module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out_0,
    output reg clk_out_90,
    output reg clk_out_180,
    output reg clk_out_270
);
    reg [1:0] clk_div;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_div <= 2'b00;
            clk_out_0 <= 0;
            clk_out_90 <= 0;
            clk_out_180 <= 0;
            clk_out_270 <= 0;
        end else begin
            clk_div <= clk_div + 1;
            case (clk_div)
                2'b00: begin
                    clk_out_0 <= 1;
                    clk_out_90 <= 0;
                    clk_out_180 <= 0;
                    clk_out_270 <= 0;
                end
                2'b01: begin
                    clk_out_0 <= 0;
                    clk_out_90 <= 1;
                    clk_out_180 <= 0;
                    clk_out_270 <= 0;
                end
                2'b10: begin
                    clk_out_0 <= 0;
                    clk_out_90 <= 0;
                    clk_out_180 <= 1;
                    clk_out_270 <= 0;
                end
                2'b11: begin
                    clk_out_0 <= 0;
                    clk_out_90 <= 0;
                    clk_out_180 <= 0;
                    clk_out_270 <= 1;
                end
            endcase
        end
    end
endmodule