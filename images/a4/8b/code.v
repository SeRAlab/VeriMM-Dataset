module reg_with_enable(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [7:0] data_in,
    output reg [7:0] data_out
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 8'd0;
    else if (en)
        data_out <= data_in;
end

endmodule