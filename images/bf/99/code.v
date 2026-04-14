module subtractor(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   diff
);

    // Subtraction operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            diff <= 0;
        end else begin
            diff <= a - b;
        end
    end

endmodule