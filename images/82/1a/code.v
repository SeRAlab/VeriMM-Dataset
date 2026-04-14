module top_module(
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'b00000000;  // Asynchronous reset to all zeros
        end else begin
            q <= {q[6:0], serial_in};  // Shift in serial input
        end
    end

endmodule