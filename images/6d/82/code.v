module parallel_register(
    input clk,
    input clear_n,
    input [63:0] data_in,
    output reg [63:0] data_out
    );

    always @(posedge clk) begin
        if (!clear_n)
            data_out <= 64'b0;
        else
            data_out <= data_in;
    end
endmodule