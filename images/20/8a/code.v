module down_counter (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b1111; // Reset to 15
    end else if (enable && count > 0) begin
        count <= count - 1; // Decrement if enabled
    end
end

endmodule