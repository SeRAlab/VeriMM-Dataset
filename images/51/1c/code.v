module parallel_load_register (
    input clk,
    input load,
    input clear,
    input [3:0] data_in,
    output reg [3:0] data_out
);

    always @(posedge clk) begin
        if (clear)
            data_out <= 4'b0000;
        else if (load)
            data_out <= data_in;
    end

endmodule