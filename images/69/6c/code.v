module register_4bit_load(
    input [3:0] data,
    input clk,
    input load,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
    end

endmodule