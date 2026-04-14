module JK_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire reset,
    output reg Q,
    output reg Q_bar
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 1'b0;
        Q_bar <= 1'b1;
    end else begin
        case ({J, K})
            2'b00: begin
                Q <= Q; // No change
            end
            2'b01: begin
                Q <= 1'b0; // Reset
            end
            2'b10: begin
                Q <= 1'b1; // Set
            end
            2'b11: begin
                Q <= ~Q; // Toggle
            end
        endcase
        Q_bar <= ~Q; // Update Q_bar
    end
end

endmodule