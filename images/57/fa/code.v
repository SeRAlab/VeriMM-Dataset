module register_16bit(
    input               clk     ,
    input               reset   ,
    input               enable  ,
    input       [15:0]  d       ,
    output  reg [15:0]  q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0000000000000000;
        end else if (enable) begin
            q <= d;
        end
    end

endmodule