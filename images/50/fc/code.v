module shift_register_32bit(
    input clk,
    input reset,
    input load,
    input shift_left,
    input [31:0] data,
    output reg [31:0] q
);

always @(posedge clk or posedge reset)
    if (reset) begin
        q <= 32'b00000000000000000000000000000000; // Reset shift register to 0
    end else begin
        if (load) begin
            q <= data; // Load data input
        end else if (shift_left) begin
            q <= q << 1; // Shift left
        end
    end

endmodule