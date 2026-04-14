module bitwise_and(
    input               clk     ,
    input               rst_n   ,
    input       [7:0]   data_in1,
    input       [7:0]   data_in2,

    output  reg [7:0]   data_out
);

    // Bitwise AND operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= data_in1 & data_in2;
        end
    end

endmodule