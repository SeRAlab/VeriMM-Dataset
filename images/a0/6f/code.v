module shift_register(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire shift,
    input wire [4:0] data_in,
    output reg [4:0] data_out
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 5'd0;
    else if (load)
        data_out <= data_in;
    else if (shift)
        data_out <= {data_out[3:0], 1'b0};
end

endmodule