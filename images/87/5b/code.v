module shift_register (
    input wire clk,
    input wire rstn,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk)
begin
    if (~rstn)
        data_out <= 8'b00000000;
    else if (load)
        data_out <= data_in;
    else
        data_out <= {1'b0, data_out[7:1]};
end

endmodule