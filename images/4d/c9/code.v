module lfsr(
    input clk,
    input reset,
    
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b00000001; // Non-zero initial value
    end else begin
        q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]}; // Tap positions: 8, 6, 5, 4
    end
end

endmodule