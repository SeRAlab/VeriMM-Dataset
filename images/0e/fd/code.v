module two_bit_counter (
    input wire clk,
    input wire rst,
    output reg [1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 2'b00; // Reset counter to 0
    end else begin
        count <= count + 1; // Increment counter
    end
end
endmodule