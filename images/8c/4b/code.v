module gray_counter (
    input clk,
    input reset,
    output reg [3:0] gray
);reg [3:0] binary;

always @(posedge clk) begin
    if (reset) begin
        binary <= 4'b0000;
        gray <= 4'b0000;
    end else begin
        binary <= binary + 1;
        gray <= binary ^ (binary >> 1);
    end
end

endmodule