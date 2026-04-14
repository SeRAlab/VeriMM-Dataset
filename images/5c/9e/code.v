module shift_register(
    input           clk,
    input           rst_n,
    input           shift_left,
    input           shift_right,
    input   [7:0]   data_in,
    
    output  reg [7:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 8'b00000000;
    else if (shift_left)
        data_out <= {data_out[6:0], data_in[7]};
    else if (shift_right)
        data_out <= {data_in[0], data_out[7:1]};
end

endmodule