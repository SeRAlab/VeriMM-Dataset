module deadbeat_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] x,     // 2-bit input
    output reg [1:0] y      // 2-bit output
);
    reg [1:0] x_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 2'b00;      // Reset output
            x_reg <= 2'b00;  // Reset registered input
        end else begin
            x_reg <= x;      // Register the input
            y <= x_reg;      // Output the registered input
        end
    end
endmodule