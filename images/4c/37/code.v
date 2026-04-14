module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            q <= {q[3:0], q[4]}; // Shift left and wrap MSB to LSB
        end
    end

endmodule