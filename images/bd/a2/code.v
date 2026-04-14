module register_with_load(
    input               clk,
    input               rst,
    input               load,
    input   [15:0]      data_in,
    
    output reg [15:0]   data_out
);

always@(posedge clk) begin
    if (rst)
        data_out <= 16'b0000000000000000;
    else if (load)
        data_out <= data_in;
end

endmodule