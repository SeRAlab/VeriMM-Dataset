module right_shifter(
    input               clk         ,
    input               rst_n       ,
    input       [15:0]  data_in     ,
    input       [3:0]   shift_amount,

    output  reg [15:0]  data_out
);

    // Shift operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            data_out <= data_in >> shift_amount;
        end
    end

endmodule