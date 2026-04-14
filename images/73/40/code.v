module shift_register (
    input wire clk,
    input wire rstn,
    input wire serial_in,
    output reg [7:0] data_out
);

always @(posedge clk)
begin
    if (~rstn)
        data_out <= 8'b00000000;
    else
        data_out <= {data_out[6:0], serial_in};
end

endmodule