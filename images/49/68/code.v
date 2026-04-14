module subtractor_8bit(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   diff    ,
    output  reg         borrow_out
);

    // 8-bit subtraction operation with borrow-out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            diff <= 0;
            borrow_out <= 0;
        end else begin
            {borrow_out, diff} <= a - b;
        end
    end

endmodule