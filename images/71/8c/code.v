module gray_counter (
    input clk,
    input rst,
    output reg [3:0] gray
);
    reg [3:0] binary;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            binary <= 4'b0000;
            gray <= 4'b0000;
        end else begin
            binary <= binary + 1;
            gray <= (binary >> 1) ^ binary;
        end
    end
endmodule