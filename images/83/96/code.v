module arith_right_shifter(
    input               clk         ,
    input               rst_n       ,
    input signed [7:0]  data_in     ,
    input       [2:0]   shift_amount,

    output  reg signed [7:0]  data_out
);

    // Arithmetic shift operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= data_in >>> shift_amount;
        end
    end

endmodule