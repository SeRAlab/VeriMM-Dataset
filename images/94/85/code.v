module rotate_left(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   data_in ,

    output  reg [7:0]   data_out
);

    // 4-bit rotation to the left operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= {data_in[3:0], data_in[7:4]};
        end
    end

endmodule