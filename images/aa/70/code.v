module top_module(
    input  wire clk,       // System clock
    input  wire rst,       // Global reset signal (active high)
    input  wire en,        // Global enable signal (active high)
    input  wire in,        // Input signal
    output reg  out        // Output signal
);reg in_delayed;

    always @(posedge clk) begin
        if (rst) begin
            out <= 1'b0;
        end else if (en) begin
            out <= ~in_delayed;
        end;
        in_delayed <= in;
    end

endmodule