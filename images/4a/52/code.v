module parallel_load_register (
    input clk,
    input load,
    input [7:0] data,
    output reg [7:0] q
);always @(posedge clk) begin
        if (load)
            q <= data;
    end

endmodule