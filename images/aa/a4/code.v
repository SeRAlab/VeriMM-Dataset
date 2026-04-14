module reg_8bit(
    input wire [7:0] d,
    input wire clk,
    output reg [7:0] q
);

    always @(posedge clk) begin
        q <= d;
    end
endmodule