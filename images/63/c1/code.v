module up_counter (
    input wire rst_n,
    input wire clk,
    input wire en,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (!rst_n)
        count <= 3'b000;
    else if (en)
        count <= count + 1;
end

endmodule