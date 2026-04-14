module shift_register(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] parallel_in,
    output reg [3:0] data_out
);

    always @(posedge clk) begin
        if (reset)
            data_out <= 0;
        else if (load)
            data_out <= parallel_in;
        else if (enable)
            data_out <= {data_out[2:0], 1'b0};
    end

endmodule