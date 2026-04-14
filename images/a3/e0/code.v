module reg8_en_ar (
    input wire [7:0] d,
    input wire clk,
    input wire en,
    input wire rst,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (en) begin
            q <= d;
        end
    end

endmodule