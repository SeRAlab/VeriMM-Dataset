module parallel_load_register(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [7:0] data_in,
    output reg [7:0] reg_out
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        reg_out <= 8'b00000000;
    else if (load)
        reg_out <= data_in;
    else
        reg_out <= reg_out;
end

endmodule