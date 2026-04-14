module reg_8bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else if (en)
            q <= d;
    end

endmodule