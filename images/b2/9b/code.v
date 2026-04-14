module register_8bit(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b0;
        end else if (en) begin
            q <= data;
        end
    end

endmodule