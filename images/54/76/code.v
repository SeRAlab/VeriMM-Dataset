module gray_code_counter (
    input clk,
    input reset_n,
    output reg [3:0] gray
);
    reg [3:0] binary;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            binary <= 4'b0000;
            gray <= 4'b0000;
        end else begin
            binary <= binary + 1;
            gray <= binary ^ (binary >> 1);
        end
    end

endmodule