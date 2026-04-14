module gray_code_counter (
    input clk,
    input reset,
    output reg [3:0] gray
);

    reg [3:0] binary;

    always @(posedge clk or posedge reset) begin
        if (reset)
            binary <= 4'b0000;
        else
            binary <= binary + 1;
    end

    always @(*) begin
        gray = binary ^ (binary >> 1);
    end
endmodule