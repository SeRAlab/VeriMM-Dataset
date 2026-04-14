module binary_counter_4bit
(
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 4'd0;
    end
    else if (en) begin
        count <= count + 1;
    end
end

endmodule