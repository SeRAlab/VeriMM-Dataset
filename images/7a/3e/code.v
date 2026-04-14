module parallel_load_register (
    input [3:0] d,
    input clk,
    input load,
    output reg [3:0] q
);

    always_ff @(posedge clk) begin
        if (load)
            q <= d;
    end

endmodule