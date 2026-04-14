module rotate_right(
    input               clk     ,
    input               rst_n   ,
    input       [15:0]  data_in ,

    output  reg [15:0]  data_out
);

    // Rotate right operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= {data_in[2:0], data_in[15:3]};
        end
    end

endmodule