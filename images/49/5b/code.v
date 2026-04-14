module top_module(
    input clk,
    input reset,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 2'b00
            q <= 2'b00;
        end else begin
            // Gray code counter: Next state logic
            case (q)
                2'b00: q <= 2'b01;
                2'b01: q <= 2'b11;
                2'b11: q <= 2'b10;
                2'b10: q <= 2'b00;
            endcase
        end
    end

endmodule