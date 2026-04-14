module register_8bit(
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= data_in;
    end
endmodule