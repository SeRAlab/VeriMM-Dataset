module async_register(
    input clk,
    input clr,
    input en,
    input [11:0] data_in,
    output reg [11:0] data_out
);

always @(posedge clk or posedge clr) begin
    if (clr)
        data_out <= 12'b0;
    else if (en)
        data_out <= data_in;
end

endmodule