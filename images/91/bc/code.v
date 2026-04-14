module arith_shifter_left(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   data_in ,

    output  reg [7:0]   data_out
);

    // Arithmetic shift left operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= {data_in[6:0], 1'b0};
        end
    end

endmodule