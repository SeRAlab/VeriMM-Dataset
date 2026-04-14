module shift_register(
    input               clk,
    input               rst,
    input               load,
    input               shift,
    input   [3:0]       data_in,
    
    output reg [3:0]    data_out
);

always@(posedge clk) begin
    if (rst)
        data_out <= 4'b0000;
    else if (load)
        data_out <= data_in;
    else if (shift)
        data_out <= data_out << 1;
end

endmodule