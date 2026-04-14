module arith_shifter_right(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   data_in ,

    output  reg [7:0]   data_out
);

    // Arithmetic shift right operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= {data_in[7], data_in[7:1]};
        end
    end

endmodule