module ShiftRegister (
    input wire clk,
    input wire load,
    input wire [15:0] parallel_in,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= parallel_in;  // Load the input when 'load' is high
    end else begin
        q <= {1'b0, q[15:1]};  // Shift right, fill with 0
    end
end

endmodule