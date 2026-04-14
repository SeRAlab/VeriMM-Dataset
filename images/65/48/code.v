module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output [15:0] q);// 16-bit output of the sum module

    // 2-to-1 multiplexer
    wire mux_out;
    assign mux_out = (sel_b1 & sel_b2) ? q : a;

    // 4-digit binary counter
    reg [3:0] digit0 = 0;
    reg [3:0] digit1 = 0;
    reg [3:0] digit2 = 0;
    reg [3:0] digit3 = 0;

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 0;
            digit1 <= 0;
            digit2 <= 0;
            digit3 <= 0;
        end else begin
            digit0 <= digit0 + 1;
            if (digit0 == 16) begin
                digit0 <= 0;
                digit1 <= digit1 + 1;
            end
            if (digit1 == 16) begin
                digit1 <= 0;
                digit2 <= digit2 + 1;
            end
            if (digit2 == 16) begin
                digit2 <= 0;
                digit3 <= digit3 + 1;
            end
            if (digit3 == 16) begin
                digit3 <= 0;
            end
        end
    end

    // Sum module
    wire [15:0] sum;
    assign sum = mux_out + ((digit3 << 12) | (digit2 << 8) | (digit1 << 4) | digit0);

    // Output
    assign q = sum;

endmodule