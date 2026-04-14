module multiplier(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [15:0]  product
);

    // Multiplication operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 0;
        end else begin
            product <= a * b;
        end
    end

endmodule