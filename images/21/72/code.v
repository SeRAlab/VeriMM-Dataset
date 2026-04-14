module shift_register (
    input wire clk,
    input wire rst,
    input wire si,
    output reg [7:0] so
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            so <= 8'b00000000;
        end else begin
            so <= {si, so[7:1]}; // Shift right
        end
    end
endmodule