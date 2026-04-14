module binary_up_counter (
    input clk,
    input rst_n,
    input en,
    output reg [11:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 12'b000000000000;
    else if (en)
        count <= count + 1;
end

endmodule