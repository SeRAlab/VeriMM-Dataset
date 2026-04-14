module ring_counter (
    input clk,
    input reset,
    output [4:0] count
);

    reg [4:0] ring_reg;  // 5-bit ring counter register

    always @(posedge clk) begin
        if (reset) begin
            ring_reg <= 5'b00001;  // Reset the counter to initial state
        end else begin
            ring_reg <= {ring_reg[3:0], ring_reg[4]};  // Ring counter logic
        end
    end

    assign count = ring_reg;

endmodule