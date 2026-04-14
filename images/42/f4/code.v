module adder_8bit(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   sum     ,
    output  reg         carry_out
);

    // 8-bit addition operation with carry-out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
            carry_out <= 0;
        end else begin
            {carry_out, sum} <= a + b;
        end
    end

endmodule