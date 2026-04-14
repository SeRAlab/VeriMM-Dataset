module ring_counter (
    input wire clk,
    input wire rst,
    output reg [4:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 5'b00001; // Initialize counter to 00001 on reset
    end else begin
        q <= {q[3:0], q[4]}; // Shift the '1' to the left
    end
end

endmodule