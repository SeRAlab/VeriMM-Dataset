module sync_counter_4bit
(
    input clk,
    input rst_n,
    input en,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;
    end
    else if (en) begin
        count <= count + 1;
    end
end

endmodule