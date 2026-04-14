module sync_register(
    input clk,
    input clr,
    input en,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk) begin
    if (clr)
        data_out <= 16'b0;
    else if (en)
        data_out <= data_in;
end

endmodule