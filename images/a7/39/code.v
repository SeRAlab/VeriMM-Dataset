module adder(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   a       ,
    input       [7:0]   b       ,

    output  reg [7:0]   sum
);

    // Addition operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
        end else begin
            sum <= a + b;
        end
    end

endmodule