module and_8bit(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   out     
);

    // 8-bit AND operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 0;
        end else begin
            out <= a & b;
        end
    end

endmodule