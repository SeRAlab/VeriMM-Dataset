module divide_by_8 (
    input wire clk,
    input wire reset,
    output reg [2:0] quotient
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        quotient <= 3'b000;
    end else begin
        quotient <= quotient + 1;
    end
end

endmodule