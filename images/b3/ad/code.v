module shift_register_8bit(
    input wire clk,
    input wire rst,
    input wire shift,
    output reg [7:0] Q
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Q <= 8'b00000000;
    end else begin
        if (shift) begin
            Q <= Q << 1;
        end else begin
            Q <= Q >> 1;
        end
    end
end

endmodule