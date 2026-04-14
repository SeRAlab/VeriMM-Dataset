module sign_extend_4to8(
    input               clk     ,
    input               rst_n   ,
    input       [3:0]   data_in ,

    output  reg [7:0]   data_out
);

    // 4-bit sign extension to 8-bit
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= {{4{data_in[3]}}, data_in};
        end
    end

endmodule