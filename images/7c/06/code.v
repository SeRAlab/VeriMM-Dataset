module parallel_load_shift_register(
    input               clk,
    input               rst,
    input               load,
    input   [7:0]       data_in,
    
    output reg [7:0]    data_out
);

always@(posedge clk or posedge rst) begin
    if (rst)
        data_out <= 8'b00000000;
    else if (load)
        data_out <= data_in;
    else
        data_out <= {data_out[6:0], 1'b0};
end

endmodule