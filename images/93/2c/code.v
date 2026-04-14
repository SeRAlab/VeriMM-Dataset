module reg8(
    input clk,
    input rst,
    input load,
    input [7:0] d,
    output reg [7:0] q
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= d;
        end
    end
endmodule