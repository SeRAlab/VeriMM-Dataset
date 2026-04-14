module divide_by_8 (
    input wire clk,
    input wire reset,
    input wire [2:0] in_num,
    output reg [2:0] out_num
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_num <= 3'b000;
    end else begin
        out_num <= in_num / 3'b1000; // divide by 8
    end
end

endmodule