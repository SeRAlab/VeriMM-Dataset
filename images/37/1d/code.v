module shift_register (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [3:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 4'b0000; // Clear the register
    end else begin
        q <= {serial_in, q[3:1]}; // Shift right and insert serial input
    end
end

endmodule