module shift_register(
    input               clk,
    input               rst,
    input               load,
    input [7:0]         parallel_in,
    input               serial_in,
    
    output reg [7:0]    data_out
);

always@(posedge clk or posedge rst) begin
    if (rst)
        data_out <= 8'b00000000;
    else if (load)
        data_out <= parallel_in;
    else
        data_out <= {data_out[6:0], serial_in};
end

endmodule