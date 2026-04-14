module down_counter (
    input wire rst_n,
    input wire clk,
    input wire en,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (!rst_n)
        count <= 4'b1111;
    else if (en)
        count <= count - 1;
end

endmodule