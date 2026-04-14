module pll_2x (
    input wire clk_in,
    input wire reset,
    output reg clk_out1,
    output reg clk_out2
);
    reg [1:0] state;
    reg [1:0] next_state;
    reg clk_div;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            clk_div <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            2'b00: begin
                next_state = 2'b01;
                clk_div = 0;
            end
            2'b01: begin
                next_state = 2'b10;
                clk_div = 1;
            end
            2'b10: begin
                next_state = 2'b00;
                clk_div = 1;
            end
            default: begin
                next_state = 2'b00;
                clk_div = 0;
            end
        endcase
    end

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out1 <= 0;
            clk_out2 <= 0;
        end else begin
            clk_out1 <= clk_div;
            clk_out2 <= ~clk_div;
        end
    end
endmodule