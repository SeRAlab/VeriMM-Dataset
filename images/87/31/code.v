module and_operation(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   result
);

    // Bitwise AND operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
        end else begin
            result <= a & b;
        end
    end

endmodule